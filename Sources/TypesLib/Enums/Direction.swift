//
//  Direction.swift
//  types-lib
//
//  Created by Georgie Ivanov on 19.05.25.
//

import Fluent

public enum Direction: String, Codable, Sendable {
    public func getName() -> String? {
        switch(self){
        case .inbound:
            return "Входящ"
        case .outbound:
            return "Изходящ"
        }
    }
    
    public static func prepareEnumMigration(database: any FluentKit.Database) async throws -> FluentKit.DatabaseSchema.DataType {
        try await database.enum(Direction.registerName)
            .case("inbound")
            .case("outbound")
            .create()
    }
    
    public static var registerName: String = "invoiceDirection"
    
    case inbound
    case outbound
}
