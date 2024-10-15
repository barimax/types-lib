import Vapor
import Fluent


final class TypesLib {
    static func migrateTypesLib(app: inout Application){
        app.migrations.add(Company.Migration())
    }
}

