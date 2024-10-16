//
//  AuthResponse.swift
//  types-lib
//
//  Created by Georgie Ivanov on 14.10.24.
//

import Vapor

struct AuthResponse: Content, Codable {
    
    let token: String
    let companies: [Company]
    let user: User
    
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
