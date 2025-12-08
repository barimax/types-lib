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
    let publicKey: PublicKeyCredentialCreationOptions
}

public struct RequestOptionsResponse: Content {
    let publicKey: PublicKeyCredentialRequestOptions
}

public struct StartRegisterRequest: Content {
    let email: String
    let displayName: String?
}

public struct StartLoginRequest: Content {
    let email: String
}
