//
//  UserToken.swift
//  types-lib
//
//  Created by Georgie Ivanov on 14.10.24.
//

@preconcurrency import Fluent
@preconcurrency import Vapor

@preconcurrency
final class Token: Model, Content {
    static let schema = "tokens"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "value")
    var value: String

    @Parent(key: "user_id")
    var user: User

    init() {}

    init(id: UUID? = nil, value: String, userID: User.IDValue) {
        self.id = id
        self.value = value
        self.$user.id = userID
    }
}


extension Token: ModelTokenAuthenticatable {
    
    
    static let valueKey = \Token.$value
    static let userKey = \Token.$user

    var isValid: Bool {
        true
    }
}

extension User {
    func generateToken() throws -> Token {
        try .init(
            value: [UInt8].random(count: 16).base64,
            userID: self.requireID()
        )
    }
}
