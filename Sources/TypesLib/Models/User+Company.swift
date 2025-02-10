//
//  User+Company.swift
//  types-lib
//
//  Created by Georgie Ivanov on 14.10.24.
//

import Vapor
import Fluent


public enum UserCompanyRole: String, Codable {
    case canDelete
    case canEdit
    case canShare
    
    static let owner: [UserCompanyRole] = [.canDelete, .canEdit, .canShare]
    static let sharedWith: [UserCompanyRole] = [.canShare]
}

public final class UserCompanyRelation: Model {
    
    public static let schema: String = "user+company"
    
    @ID()
    public var id: UUID?
    
    @Parent(key: "user_id")
    public var user: User
    
    @Parent(key: "company_id")
    public var company: Company
    
    @Field(key: "user_company_roles")
    public var userCompanyRoles: [UserCompanyRole]
    
    public init() {}
    
    public init(user: User, company: Company, userCompanyRoles: [UserCompanyRole]) {
        self.user = user
        self.company = company
        self.userCompanyRoles = userCompanyRoles
    }
    
    
}
