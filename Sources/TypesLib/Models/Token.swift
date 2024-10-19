//
//  UserToken.swift
//  types-lib
//
//  Created by Georgie Ivanov on 14.10.24.
//

@preconcurrency import Fluent
@preconcurrency import Vapor

@preconcurrency
public final class Token: Model, Content {
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


extension Token: ModelTokenAuthenticatable {
    
    
    public static let valueKey = \Token.$value
    public static let userKey = \Token.$user

    public var isValid: Bool {
        true
    }
}

public extension User {
    func generateToken() throws -> Token {
        try .init(
            value: [UInt8].random(count: 16).base64,
            userID: self.requireID()
        )
    }
}
