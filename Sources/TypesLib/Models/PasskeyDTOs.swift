//
//  CreationOptionsResponse.swift
//  types-lib
//
//  Created by Georgie Ivanov on 8.12.25.
//


import WebAuthn
import Vapor

// Wrapper so JSON matches what WebAuthn/Flutter expect: { "publicKey": { ... } }
public struct CreationOptionsResponse: Content {
    public let publicKey: PublicKeyCredentialCreationOptions
    
    public init(publicKey: PublicKeyCredentialCreationOptions) {
        self.publicKey = publicKey
    }
}

public struct RequestOptionsResponse: Content {
    public let publicKey: PublicKeyCredentialRequestOptions
    
    public init(publicKey: PublicKeyCredentialRequestOptions) {
        self.publicKey = publicKey
    }
}

public struct StartRegisterRequest: Content {
    public let email: String
    public let displayName: String?
    
    public init(email: String, displayName: String?) {
        self.email = email
        self.displayName = displayName
    }
}

public struct StartLoginRequest: Content {
    public let email: String
    
    public init(email: String) {
        self.email = email
    }
}
