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
        self.migrations.add(Token.Migration())
        self.migrations.add(Accountant.Migration())
        self.migrations.add(User.AddOTPMigration())
        self.migrations.add(User.AddIsOTPMigration())
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
            app.databases.use(.mysql(configuration: mysqlConfig), as: databaseID)
            req.logger.info("[JORO] Database migration count \(migrations.count)")
            app.migrations.add(migrations, to: databaseID)
            try await app.autoMigrate()
            
            return .ok
        }
    }
}


