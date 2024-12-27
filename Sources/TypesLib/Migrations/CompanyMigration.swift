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
                .field("uin", .string, .required)
                .field("database", .string)
                .field("configuration", .json)
                .field("owner", .uuid)
                .create()
        }

        func revert(on database: Database) async throws {
            try await database.schema(Company.schema).delete()
        }
    }
}
