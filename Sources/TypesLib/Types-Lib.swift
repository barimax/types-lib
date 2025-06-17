import Vapor
import Fluent
import MySQLKit
import FluentMySQLDriver

public class Configuration {
    @available(*, deprecated)
    public static var encoder: JSONEncoder = JSONEncoder()
    @available(*, deprecated)
    public static var decoder: JSONDecoder = JSONDecoder()
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
    }
    
    func encoderSetup() {
        // JSON coding configuration
        let decoder = JSONDecoder()
        let encoder = JSONEncoder()
        let formater = DateFormatter()
        formater.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formater.timeZone = TimeZone(abbreviation: "GMT")
        decoder.dateDecodingStrategy = .formatted(formater)
        encoder.dateEncodingStrategy = .formatted(formater)
        Configuration.encoder = encoder
        Configuration.decoder = decoder
        ContentConfiguration.global.use(decoder: decoder, for: .json)
        ContentConfiguration.global.use(encoder: encoder, for: .json)
        appConfiguration = Configuration(encoder: encoder, decoder: decoder)
    }
}

public final class TypesLib {
    public static func typesLibConfiguration(_ app: Application, configuration: MySQLConfiguration, migrations: [AsyncMigration]) throws {
        app.post("spi", "setNewDatabase", ":databaseID") { req async throws  -> HTTPStatus in
            guard let database = req.parameters.get("databaseID") else {
                throw Abort(.badRequest, reason: "Missing databaseID")
            }
            let databaseID = DatabaseID(string: database)
            var tls = TLSConfiguration.makeClientConfiguration()
            tls.certificateVerification = .none
            var mysqlConfig = configuration
            mysqlConfig.database = database
            mysqlConfig.tlsConfiguration = tls
            app.databases.use(.mysql(configuration: mysqlConfig), as: databaseID)
            req.logger.info("[JORO] Database migration count \(migrations.count)")
            app.migrations.add(migrations, to: databaseID)
            try await app.autoMigrate()
            
            return .ok
        }
    }
}


