//
//  Passkey.swift
//  types-lib
//
//  Created by Georgie Ivanov on 8.12.25.
//
import Vapor
import Fluent

final class Passkey: Model, Content, @unchecked Sendable {
    static let schema = "passkeys"

    @ID(custom: "id", generatedBy: .user) // credential ID is string
    var id: String?

    @Field(key: "public_key")
    var publicKey: String // base64url

    @Field(key: "sign_count")
    var currentSignCount: Int

    @Parent(key: "user_id")
    var user: User

    init() {}

    init(
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
