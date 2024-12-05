import Vapor
import Fluent

class Configuration {
    static var encoder: JSONEncoder = JSONEncoder()
    static var decoder: JSONDecoder = JSONDecoder()
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
