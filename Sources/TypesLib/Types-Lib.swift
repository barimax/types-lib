import Vapor
import Fluent


public final class TypesLib {
    public static func migrateTypesLib(app: inout Application){
        app.migrations.add(Company.Migration())
    }
}

