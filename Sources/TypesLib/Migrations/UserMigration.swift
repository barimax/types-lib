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
        
        func prepare(on database: any Database) async throws {
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
                .create()
        }

        func revert(on database: any Database) async throws {
            try await database.schema(User.schema).delete()
            try await database.enum("user_role").delete()
        }
        
    }
    
    struct AddOTPMigration: AsyncMigration {
        
        var name: String = "User.AddOTPMigration"
        
        func prepare(on database: any Database) async throws {
            try await database.schema(User.schema)
                .field("otp_secret", .uuid)
                .update()
        }

        func revert(on database: any Database) async throws {
            try await database.schema(Company.schema)
                .deleteField("otp_secret")
                .update()
        }
        
    }
}
