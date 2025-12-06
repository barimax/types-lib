//
//  TokenMigration.swift
//  types-lib
//
//  Created by Georgie Ivanov on 14.10.24.
//

import Fluent
import Vapor

extension Token {
    struct Migration: AsyncMigration {
        
        var name: String { "Token.Migration" }
        
        func prepare(on database: any FluentKit.Database) async throws {
            try await database.schema(Token.schema)
                .id()
                .field("value", .string, .required)
                .field("user_id", .uuid, .required, .references(User.schema, "id"))
                .unique(on: "value")
                .create()
        }
        
        func revert(on database: any FluentKit.Database) async throws {
            try await database.schema(Token.schema).delete()
        }
    }
}
