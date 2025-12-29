//
//  AuthResponse.swift
//  types-lib
//
//  Created by Georgie Ivanov on 14.10.24.
//

import Vapor

public struct LoginResponse: Content {
    public let isOTP: Bool
    public let challenge: String?
    
    public init(isOTP: Bool, challange: String?) {
        self.isOTP = isOTP
        self.challenge = challange
    }
}

public struct OTPSecret: Content {
    public let secret: String
    
    public init(secret: String) {
        self.secret = secret
    }
}

public struct Token<T>: Content where T: Codable & Sendable {
    public let token: String
    public let isOTP: Bool?
    public let isPasskeyEnabled: Bool
    public let userId: String
    public let email: String
    public let name: String
    public let data: T?
    
    public init(token: String, isOTP: Bool?, isPasskeyEnabled: Bool, userId: String, email: String, name: String, data: T? = nil) {
        self.token = token
        self.isOTP = isOTP
        self.isPasskeyEnabled = isPasskeyEnabled
        self.userId = userId
        self.email = email
        self.name = name
        self.data = data
    }
}
