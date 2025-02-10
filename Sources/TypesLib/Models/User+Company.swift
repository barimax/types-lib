//
//  User+Company.swift
//  types-lib
//
//  Created by Georgie Ivanov on 14.10.24.
//

import Vapor
import Fluent

public enum UserCompanyRight: String, Codable {
    case canShare
    case canDelete
    case canEdit
}

public enum UserCompanyRole: Codable {
    case owner(with: [UserCompanyRight] = [.canShare, .canDelete, .canEdit])
    case sharedWith(with: [UserCompanyRight] = [.canEdit])
}

public final class UserCompanyRelation: Model {
    
    public static let schema: String = "user+company"
    
    @ID()
    public var id: UUID?
    
    @Parent(key: "user_id")
    public var user: User
    
    @Parent(key: "company_id")
    public var company: Company
    
    @Field(key: "user_company_role")
    public var userCompanyRole: UserCompanyRole
    
    public init() {}
    
    public init(user: User, company: Company, userCompanyRole: UserCompanyRole) {
        self.user = user
        self.company = company
        self.userCompanyRole = userCompanyRole
    }
    
}
