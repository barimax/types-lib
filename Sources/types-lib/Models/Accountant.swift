//
//  Accountant.swift
//  types-lib
//
//  Created by Georgie Ivanov on 14.10.24.
//

import Vapor
import Fluent

final class Accountant: Model, Content {
    
    static let schema: String = "accountants"
    static var optionField: AnyKeyPath = \Accountant.name
    static var registerName: String = "accountant"
 
    
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

    @Field(key: "email")
    var email: String

    @Field(key: "password_hash")
    var accTokenHash: String
    
    @Field(key: "approved")
    var approved: Bool
    
    @Field(key: "companies")
    var companies: [Company]
    
    
    
    init() { }

    init(id: UUID? = nil, name: String, email: String, accTokenHash: String, approved: Bool, confirmationCode: String?, companies: [Company]) {
        self.id = id
        self.name = name
        self.email = email
        self.accTokenHash = accTokenHash
        self.approved = approved
        self.companies = companies
    }
}
