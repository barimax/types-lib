import Vapor
import Fluent


public final class TypesLib {
    public static func migrateTypesLib(app: inout Application){
        app.migrations.add(Company.Migration())
        app.migrations.add(User.Migration())
        app.migrations.add(UserCompanyRelation.Migration())
        app.migrations.add(Token.Migration())
        app.migrations.add(Accountant.Migration())
    }
}

