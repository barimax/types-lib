//
//  AuthResponse.swift
//  types-lib
//
//  Created by Georgie Ivanov on 14.10.24.
//

import Vapor

public struct AuthResponse: Content, Codable {
    
    public let token: String
    public let companies: [Company]
    public let user: User
    
    init(
        token: String,
        companies: [Company],
        user: User
    ) {
        self.token = token
        self.companies = companies
        self.user = user
    }
}
