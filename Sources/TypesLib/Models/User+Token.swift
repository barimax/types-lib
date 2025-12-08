//
//  UserToken.swift
//  types-lib
//
//  Created by Georgie Ivanov on 14.10.24.
//

import Fluent
import Vapor
import JWT

public final class UserToken: Model, Content, @unchecked Sendable {
    public static let schema = "tokens"

    @ID(key: .id)
    public var id: UUID?

    @Field(key: "value")
    public var value: String

    @Parent(key: "user_id")
    public var user: User

    public init() {}

    public init(id: UUID? = nil, value: String, userID: User.IDValue) {
        self.id = id
        self.value = value
        self.$user.id = userID
    }
}


extension UserToken: ModelTokenAuthenticatable {
    public static var valueKey: KeyPath<UserToken, Field<String>> { \.$value }
    public static var userKey: KeyPath<UserToken, Parent<User>> { \.$user }

    public var isValid: Bool {
        true
    }
}

public extension User {
    func generateToken() throws -> UserToken {
        try .init(
            value: [UInt8].random(count: 16).base64,
            userID: self.requireID()
        )
    }
}
