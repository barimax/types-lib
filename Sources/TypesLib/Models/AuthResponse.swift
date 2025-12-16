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

public struct Token: Content {
    public let token: String
    public let isOTP: Bool?
    public let isPasskeyEnabled: Bool
    
    public init(token: String, isOTP: Bool?, isPasskeyEnabled: Bool) {
        self.token = token
        self.isOTP = isOTP
        self.isPasskeyEnabled = isPasskeyEnabled
    }
}
