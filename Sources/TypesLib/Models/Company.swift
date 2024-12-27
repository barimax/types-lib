//
//  Company.swift
//  types-lib
//
//  Created by Georgie Ivanov on 14.10.24.
//
import Vapor
import Fluent

public final class Company: Model, Content, @unchecked Sendable {

    public static let schema: String = "companies"
    
    @ID()
    public var id: UUID?
    
    @Timestamp(key: "deleted_at", on: .delete)
    var deletedAt: Date?
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?
    
    @Field(key: "name")
    public var name: String

    @Field(key: "uin")
    public var uid: String

    @OptionalField(key: "address")
    public var address: String?
    
    @OptionalField(key: "database")
    public var database: String?
    
    @OptionalField(key: "configuration")
    public var configuration: CompanyConfiguration?
    
    public var local: Bool = false

    public init() { }

    public init(id: UUID? = nil, name: String, uid: String, address: String?, database db: String, configuration c: CompanyConfiguration) {
        self.id = id
        self.name = name
        self.uid = uid
        self.address = address
        self.database = db
        self.configuration = c
    }
    
    public struct Create: Content {
        public let name: String
        public let uid: String
        public let address: String?
        public let clientsAccount: Int?
        public let suppliersAccount: Int?
        public let bankCostsAccount: Int?
        public let cashAccount: Int?
        public let register: Int?
    }
    
    public struct Update: Content {
        public let id: UUID
        public let name: String
        public let uid: String
        public let address: String?
        public let clientsAccount: Int?
        public let suppliersAccount: Int?
        public let bankCostsAccount: Int?
        public let cashAccount: Int?
        public let register: Int?
    }
    
    enum CodingKeys: String, CodingKey {
        case id, deletedAt, createdAt, updatedAt, name, uid, address, configuration, local
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(deletedAt, forKey: .deletedAt)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(updatedAt, forKey: .updatedAt)
        try container.encode(name, forKey: .name)
        try container.encode(uid, forKey: .uid)
        try container.encode(address, forKey: .address)
        try container.encode(configuration, forKey: .configuration)
        try container.encode(local, forKey: .local)
    }
}

extension Company.Create: Validatable {
    public static func validations(_ validations: inout Validations) {
        validations.add("name", as: String.self, is: !.empty)
        validations.add("uid", as: String.self, is: !.empty)
    }
}

extension Company.Update: Validatable {
    public static func validations(_ validations: inout Validations) {
        validations.add("id", as: UUID.self, is: .valid)
        validations.add("name", as: String.self, is: !.empty)
        validations.add("uid", as: String.self, is: !.empty)
    }
}
