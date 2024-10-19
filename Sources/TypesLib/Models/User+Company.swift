//
//  User+Company.swift
//  types-lib
//
//  Created by Georgie Ivanov on 14.10.24.
//

import Vapor
import Fluent

public final class UserCompanyRelation: Model {
    
    public static let schema: String = "user+company"
    
    @ID()
    public var id: UUID?
    
    @Parent(key: "user_id")
    var user: User
    
    @Parent(key: "company_id")
    var company: Company
    
    public init() {}
    
}
