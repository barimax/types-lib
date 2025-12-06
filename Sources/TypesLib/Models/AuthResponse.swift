//
//  AuthResponse.swift
//  types-lib
//
//  Created by Georgie Ivanov on 14.10.24.
//

import Vapor

public struct LoginResponse: Content {
    public let isOTP: Bool
}

public struct OTPSecret: Content {
    public let secret: String
}
