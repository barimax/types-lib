//
//  Company.swift
//  types-lib
//
//  Created by Georgie Ivanov on 14.10.24.
//
import Vapor
import Fluent

public final class Company: Model, Content{

    static let schema: String = "companies"
    
    @ID()
    var id: UUID?
    
    @Timestamp(key: "deleted_at", on: .delete)
    var deletedAt: Date?
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?
    
    @Field(key: "name")
    var name: String

    @Field(key: "uin")
    var uid: String

    @Field(key: "address")
    var address: String
    
    @Field(key: "database")
    var database: String
    
    var local: Bool = false

    init() { }

    init(id: UUID? = nil, name: String, uid: String, address: String, database db: String) {
        self.id = id
        self.name = name
        self.uid = uid
        self.address = address
        self.database = db
    }
}
