//
//  Accountant.swift
//  types-lib
//
//  Created by Georgie Ivanov on 14.10.24.
//

import Vapor
import Fluent

public final class Accountant: Model, Content {
    
    public static let schema: String = "accountants"
    public static var optionField: AnyKeyPath = \Accountant.name
    public static var registerName: String = "accountant"
 
    
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

    @Field(key: "email")
    public var email: String

    @Field(key: "password_hash")
    public var accTokenHash: String
    
    @Field(key: "approved")
    public var approved: Bool
    
    @Field(key: "companies")
    public var companies: [Company]
    
    
    
    public init() { }

    public init(id: UUID? = nil, name: String, email: String, accTokenHash: String, approved: Bool, confirmationCode: String?, companies: [Company]) {
        self.id = id
        self.name = name
        self.email = email
        self.accTokenHash = accTokenHash
        self.approved = approved
        self.companies = companies
    }
}
