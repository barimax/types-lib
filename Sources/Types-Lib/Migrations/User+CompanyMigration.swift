
import Fluent

extension UserCompanyRelation {
    struct Migration: AsyncMigration {
        
        var name: String = "UserCompanyRalation.Migration"
        
        func prepare(on database: Database) async throws {
            try await database.schema(UserCompanyRelation.schema)
                .id()
                .field("user_id", .uuid, .references(User.schema, "id"))
                .field("company_id", .uuid, .references(Company.schema, "id"))
                .create()
        }

        func revert(on database: Database) async throws {
            try await database.schema(UserCompanyRelation.schema).delete()
        }
        
    }
}
