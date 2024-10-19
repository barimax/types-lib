import Vapor
import Fluent

public extension Application {
    func addTypesLibMigrations() {
        self.migrations.add(Company.Migration())
        self.migrations.add(User.Migration())
        self.migrations.add(UserCompanyRelation.Migration())
        self.migrations.add(Token.Migration())
        self.migrations.add(Accountant.Migration())
    }
}
