//
//  CreationOptionsResponse.swift
//  types-lib
//
//  Created by Georgie Ivanov on 8.12.25.
//


import WebAuthn

// Wrapper so JSON matches what WebAuthn/Flutter expect: { "publicKey": { ... } }
struct CreationOptionsResponse: Content {
    let publicKey: PublicKeyCredentialCreationOptions
}

struct RequestOptionsResponse: Content {
    let publicKey: PublicKeyCredentialRequestOptions
}

struct StartRegisterRequest: Content {
    let email: String
    let displayName: String?
}

struct StartLoginRequest: Content {
    let email: String
}