//
//  File.swift
//
//
//  Created by Georgie Ivanov on 16.11.20.
//

import Vapor
import Fluent
import JWT

public enum UserRole: String, Codable, Sendable {
    
    public static func prepareEnumMigration(database: any FluentKit.Database) async throws -> FluentKit.DatabaseSchema.DataType {
        return try await database.enum("user_role")
            .case(Self.admin.rawValue)
            .case(Self.user.rawValue)
            .case(Self.guest.rawValue)
            .case(Self.unconfirmed.rawValue)
            .case(Self.unconfirmedAdmin.rawValue)
            .create()
    }

    public static let registerName: String = "userRole"
    
    case admin, user, guest, unconfirmed, unconfirmedAdmin
    
    public var needNewCode: Bool {
        switch(self){
        case .unconfirmed, .unconfirmedAdmin:
            return true
        default:
            return false
        }
    }
    
    public func getName() -> String? {
        switch self {
        case .admin:
            return "Администратор"
        case .unconfirmedAdmin:
            return "Непотвърден администратор"
        case .user:
            return "Потребител"
        case .unconfirmed:
            return "Непотвърден"
        case .guest:
            return "Гост"
        }
    }
}

public final class User: Model, Content, @unchecked Sendable {
    
    public static let schema: String = "users"
    nonisolated(unsafe) static var optionField: AnyKeyPath = \User.name
    static let registerName: String = "user"
 
    
    @ID()
    public var id: UUID?
    
    @Timestamp(key: "deleted_at", on: .delete)
    var deletedAt: Date?
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?
    
    @Field(key: "name")
    public var name: String

    @Field(key: "email")
    public var email: String

    @Field(key: "password_hash")
    public var passwordHash: String
    
    @Field(key: "user_role")
    public var userRole: UserRole
    
    @OptionalField(key: "confirmation_code")
    public var confirmationCode: String?
    
    @OptionalField(key: "otp_secret")
    public var otpSecret: String?
    
    @Field(key: "is_otp_confirmed")
    public var isOTPConfirmed: Bool
    
    @Timestamp(key: "confirmation_expire", on: .none)
    public var expire: Date?
    
    @Siblings(through: UserCompanyRelation.self, from: \.$user, to: \.$company)
    public var companies: [Company]
    
    
    public init() { }

    public init(id: UUID? = nil, name: String, email: String, passwordHash: String, userRole: UserRole, confirmationCode: String?, otpSecret: String?, expire: Date?) {
        self.id = id
        self.name = name
        self.email = email
        self.passwordHash = passwordHash
        self.userRole = userRole
        self.confirmationCode = confirmationCode
        self.otpSecret = otpSecret
        self.expire = expire
        self.isOTPConfirmed = false
    }
}

public extension User {
    
    static func generateCode() -> String { String(UInt32.random(in: 100000...999999)) }
    
    struct Create: Content {
        public var name: String
        public var email: String
        public var password: String
        public var confirmPassword: String
    }
    
    struct CreateCompanyOwner: Content {
        public var name: String
        public var email: String
        public var password: String
        public var confirmPassword: String
        public var companyName: String
        public var companyUIN: String
        public var companyAddress: String
    }
    struct Confirm: Content {
        public var email: String
        public var code: String
    }
    
    struct OTPConfirm: Content {
        public var code: String
    }
    
    struct Forgot: Content {
        public var email: String
    }
    struct ResetPassword: Content {
        public var email: String
        public var code: String
        public var password: String
        public var confirmPassword: String
    }
    struct JWTToken: Content {
        static let expirationTime: TimeInterval = 60 * 60 * 24
        
        var expiration: ExpirationClaim
        public var userId: UUID

        init(userId: UUID) {
            self.userId = userId
            self.expiration = ExpirationClaim(value: Date().addingTimeInterval(JWTToken.expirationTime))
        }
        
        init(with user: User) throws {
            self.userId = try user.requireID()
            self.expiration = ExpirationClaim(value: Date().addingTimeInterval(JWTToken.expirationTime))
        }
    }
}
extension User.Create: Validatable {
    public static func validations(_ validations: inout Validations) {
        validations.add("name", as: String.self, is: !.empty)
        validations.add("email", as: String.self, is: .email)
        validations.add("password", as: String.self, is: .count(8...))
    }
}

extension User.CreateCompanyOwner: Validatable {
    public static func validations(_ validations: inout Validations) {
        validations.add("name", as: String.self, is: !.empty)
        validations.add("email", as: String.self, is: .email)
        validations.add("companyName", as: String.self, is: !.empty)
        validations.add("companyUIN", as: String.self, is: !.empty)
        validations.add("companyAddress", as: String.self, is: !.empty)
        validations.add("password", as: String.self, is: .count(8...))
        validations.add("confirmPassword", as: String.self, is: .count(8...))
    }
}

extension User.Confirm: Validatable {
    public static func validations(_ validations: inout Validations) {
        validations.add("email", as: String.self, is: .email)
        validations.add("code", as: String.self, is: .count(6...6))
    }
}

extension User.OTPConfirm: Validatable {
    public static func validations(_ validations: inout Validations) {
        validations.add("secret", as: String.self, is: .email)
        validations.add("code", as: String.self, is: .count(6...6))
    }
}

extension User: ModelAuthenticatable {
    public static var usernameKey: KeyPath<User, Field<String>> { \.$email }
    public static var passwordHashKey: KeyPath<User, Field<String>> { \.$passwordHash }
    

    public func verify(password: String) throws -> Bool {
        return try Bcrypt.verify(password, created: self.passwordHash)
    }
}
extension User: ModelSessionAuthenticatable { }

extension User.JWTToken: Authenticatable, JWTPayload {
    public func verify(using algorithm: some JWTAlgorithm) throws {
        try expiration.verifyNotExpired()
    }
    
    enum CodingKeys: String, CodingKey {
        case userId = "uid"
        case expiration = "exp"
    }
}

extension User {
    public func jwtTokenPayload() throws -> User.JWTToken {
        .init(userId: try self.requireID())
    }
    public func jwtSignedToken(req: Request) async throws -> String {
        return try await req.jwt.sign(self.jwtTokenPayload())
    }
}
