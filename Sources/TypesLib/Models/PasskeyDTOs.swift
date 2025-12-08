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
}

public struct RequestOptionsResponse: Content {
    public let publicKey: PublicKeyCredentialRequestOptions
}

public struct StartRegisterRequest: Content {
    public let email: String
    public let displayName: String?
}

public struct StartLoginRequest: Content {
    public let email: String
}
