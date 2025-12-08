//
//  Passkey.swift
//  types-lib
//
//  Created by Georgie Ivanov on 8.12.25.
//
import Vapor
import Fluent

public final class Passkey: Model, Content, @unchecked Sendable {
    public static let schema = "passkeys"

    @ID(custom: "id", generatedBy: .user) // credential ID is string
    public var id: String?

    @Field(key: "public_key")
    public var publicKey: String // base64url

    @Field(key: "sign_count")
    public var currentSignCount: Int

    @Parent(key: "user_id")
    public var user: User

    public init() {}

    public init(
        id: String,
        publicKey: String,
        currentSignCount: Int,
        userID: UUID
    ) {
        self.id = id
        self.publicKey = publicKey
        self.currentSignCount = currentSignCount
        self.$user.id = userID
    }
}
