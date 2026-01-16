import Vapor
import Fluent
import MySQLKit
import FluentMySQLDriver

public actor Configuration: Sendable {
    public var encoder: JSONEncoder
    public var decoder: JSONDecoder
    
    public init(encoder: JSONEncoder = JSONEncoder(), decoder: JSONDecoder = JSONDecoder()) {
        self.encoder = encoder
        self.decoder = decoder
    }
}

public extension Application {
    struct AppConfigurationKey: StorageKey {
        public typealias Value = Configuration
    }
    var appConfiguration: Configuration {
        get {
            self.storage[AppConfigurationKey.self] ?? Configuration()
        }
        set {
            self.storage[AppConfigurationKey.self] = newValue
        }
    }
    
   
    func addTypesLibMigrations() {
        self.migrations.add(Company.Migration())
        self.migrations.add(Company.AddSoftwareType())
        self.migrations.add(User.Migration())
        self.migrations.add(UserCompanyRelation.Migration())
        self.migrations.add(UserToken.Migration())
        self.migrations.add(Accountant.Migration())
    }
    
    func encoderSetup() async {
        // JSON coding configuration
        let decoder = JSONDecoder()
        let encoder = JSONEncoder()
        let formater = DateFormatter()
        formater.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formater.timeZone = TimeZone(abbreviation: "GMT")
        decoder.dateDecodingStrategy = .formatted(formater)
        encoder.dateEncodingStrategy = .formatted(formater)
        ContentConfiguration.global.use(decoder: decoder, for: .json)
        ContentConfiguration.global.use(encoder: encoder, for: .json)
        appConfiguration = Configuration(encoder: encoder, decoder: decoder)
    }
}

public final class TypesLib {
    public static func typesLibConfiguration(_ app: Application, configuration: MySQLConfiguration, migrations: [any AsyncMigration]) throws {
        app.post("spi", "setNewDatabase", ":databaseID") { req async throws  -> HTTPStatus in
            guard let database = req.parameters.get("databaseID") else {
                req.logger.error("Missing databaseID")
                throw Abort(.badRequest, reason: "Missing databaseID")
            }
            let databaseID = DatabaseID(string: database)
            var tls = TLSConfiguration.makeClientConfiguration()
            tls.certificateVerification = .none
            var mysqlConfig = configuration
            mysqlConfig.database = database
            mysqlConfig.tlsConfiguration = tls
            req.logger.info("[JORO] New database configuration done.")
            req.logger.info("[JORO] Database migration count \(migrations.count)")
            try await migrateOnly(
                app,
                configuration: configuration,
                dbID: databaseID,
                migrations: migrations
            )
            req.logger.info("[JORO] Database migration done.")
            app.databases.use(.mysql(configuration: mysqlConfig), as: databaseID)
            req.logger.info("[JORO] Database registered to app.databases.")
//            app.migrations.add(migrations, to: databaseID)
//            try await app.autoMigrate()
            
            return .ok
        }
    }
}

func migrateOnly(_ app: Application,configuration: MySQLConfiguration, dbID: DatabaseID, migrations: [any AsyncMigration]) async throws {
    let localDatabases = Databases(
            threadPool: app.threadPool,
            on: app.eventLoopGroup,
        )
    localDatabases.use(.mysql(configuration: configuration), as: dbID)
    
    // 1) Build a local migration registry (do NOT touch app.migrations)
    let localMigrations = Migrations()

    // Add migrations targeted to this dbID
    localMigrations.add(migrations, to: dbID)

    // 2) Build a Migrator that only knows about THIS database
    // Databases is app.databases; but we want to limit to one DB.
    // FluentKit Migrator initializer accepts Databases + Migrations.
    // We'll create a shallow "Databases" view by using app.databases but only invoking on dbID.
    let migrator = Migrator(
        databases: localDatabases,
        migrations: localMigrations,
        logger: app.logger,
        on: app.eventLoopGroup.next()
    )

    // 3) Run migration only for that database
    
    do {
        try await migrator.setupIfNeeded().get()
            try await migrator.prepareBatch().get()
            await localDatabases.shutdownAsync()
        } catch {
            await localDatabases.shutdownAsync()
            throw error
        }
}

