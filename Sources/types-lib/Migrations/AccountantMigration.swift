//
//  AccountantMigration.swift
//  types-lib
//
//  Created by Georgie Ivanov on 14.10.24.
//

import Fluent
import Vapor

extension Accountant {
    struct Migration: AsyncMigration {
        
        var name: String = "Accountant.Migration"
        
        func prepare(on database: Database) async throws {
            try await database.schema(Accountant.schema)
                .id()
                .field("deleted_at", .datetime)
                .field("created_at", .datetime)
                .field("updated_at", .datetime)
                .field("name", .string, .required)
                .field("email", .string, .required)
                .field("accTokenHash", .string, .required)
                .field("approved", .bool, .required)
                .field("companies", .array, .required)
                .create()
        }

        func revert(on database: Database) async throws {
            try await database.schema(Accountant.schema).delete()
        }
        
    }
}
