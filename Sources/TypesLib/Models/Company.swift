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

    @Field(key: "address")
    public var address: String
    
    @Field(key: "database")
    public var database: String
    
    @OptionalField(key: "configuration")
    public var configuration: CompanyConfiguration?
    
    public var local: Bool = false

    public init() { }

    public init(id: UUID? = nil, name: String, uid: String, address: String, database db: String) {
        self.id = id
        self.name = name
        self.uid = uid
        self.address = address
        self.database = db
    }
}
