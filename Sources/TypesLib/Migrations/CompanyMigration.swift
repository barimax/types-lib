//
//  CompanyMigration.swift
//  types-lib
//
//  Created by Georgie Ivanov on 14.10.24.
//

import Fluent
import Vapor

extension Company {
    struct Migration: AsyncMigration {
        var name: String { "Company.Migration" }
        
        func prepare(on database: Database) async throws {
            try await database.schema(Company.schema)
                .id()
                .field("deleted_at", .datetime)
                .field("created_at", .datetime)
                .field("updated_at", .datetime)
                .field("name", .string, .required)
                .field("address", .string)
                .field("uid", .string, .required)
                .field("database", .string)
                .field("configuration", .json)
                .field("owner", .uuid)
                .unique(on: "uid", "owner")
                .create()
        }

        func revert(on database: Database) async throws {
            try await database.schema(Company.schema).delete()
        }
    }
    
    struct AddSoftwareType: AsyncMigration {
        var name: String { "Company.AddSoftwareTypeMigration" }
        
        func prepare(on database: Database) async throws {
            try await database.schema(Company.schema)
                .field("software_type", .string)
                .update()
        }

        func revert(on database: Database) async throws {
            try await database.schema(Company.schema)
                .deleteField("software_type")
                .update()
        }
    }
}
