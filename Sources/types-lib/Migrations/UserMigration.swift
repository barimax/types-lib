//
//  UserMigration.swift
//  types-lib
//
//  Created by Georgie Ivanov on 14.10.24.
//

import Fluent
import Vapor

extension User {
    struct Migration: AsyncMigration {
        
        var name: String = "User.Migration"
        
        func prepare(on database: Database) async throws {
            let userRole = try await UserRole.prepareEnumMigration(database: database)
            try await database.schema(User.schema)
                .id()
                .field("deleted_at", .datetime)
                .field("created_at", .datetime)
                .field("updated_at", .datetime)
                .field("name", .string, .required)
                .field("email", .string, .required)
                .field("password_hash", .string, .required)
                .field("user_role", userRole, .required)
                .field("confirmation_code", .string)
                .field("confirmation_expire", .datetime)
                .field("company_id", .uuid, .references(Company.schema, "id"))
                .create()
        }

        func revert(on database: Database) async throws {
            try await database.schema(User.schema).delete()
            try await database.enum("user_role").delete()
        }
        
    }
}
