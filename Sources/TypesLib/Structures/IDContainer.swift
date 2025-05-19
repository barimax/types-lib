//
//  IDContainer.swift
//  types-lib
//
//  Created by Georgie Ivanov on 19.05.25.
//
import Foundation
import Vapor

public struct IDContainer: Codable, Sendable {
    public let id: String?
    public var optionalUUID: UUID? {
        if let idString = self.id {
            return UUID(idString)
        }
        return nil
    }
    public func uuid() throws -> UUID {
        guard let uuid = self.optionalUUID else {
            throw Abort(.badRequest)
        }
        return uuid
    }
    
    public init?(id: UUID?){
        guard let uuid = id?.uuidString else{
            return nil
        }
        self.id = uuid
    }
    
    public init?(id: String?) {
        guard let idString = id else {
            return nil
        }
        self.id = idString
    }
    public init(id: String) {
        self.id = id
    }
    public init(uuid: UUID){
        self.id = uuid.uuidString
    }
}
