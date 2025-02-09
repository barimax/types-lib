import Vapor
import Fluent
import MySQLKit
import FluentMySQLDriver

public class Configuration {
    public static var encoder: JSONEncoder = JSONEncoder()
    public static var decoder: JSONDecoder = JSONDecoder()
}

public extension Application {
    
   
    func addTypesLibMigrations() {
        self.migrations.add(Company.Migration())
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
            let mysqlConfig = MySQLConfiguration(
                hostname: configuration.username,
                username: configuration.username,
                password: configuration.password,
                database: database,
                tlsConfiguration: tls
            )
            
            app.databases.use(.mysql(configuration: mysqlConfig), as: databaseID)
            app.migrations.add(migrations)
            try await app.autoMigrate()
            
            return .ok
        }
    }
}


