//
//  Direction.swift
//  types-lib
//
//  Created by Georgie Ivanov on 19.05.25.
//

import Fluent

enum Direction: String, Codable {
    func getName() -> String? {
        switch(self){
        case .inbound:
            return "Входящ"
        case .outbound:
            return "Изходящ"
        }
    }
    
    static func prepareEnumMigration(database: any FluentKit.Database) async throws -> FluentKit.DatabaseSchema.DataType {
        try await database.enum(Direction.registerName)
            .case("inbound")
            .case("outbound")
            .create()
    }
    
    static var registerName: String = "invoiceDirection"
    
    case inbound
    case outbound
}
