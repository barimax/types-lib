//
//  File.swift
//
//
//  Created by Georgie Ivanov on 16.11.20.
//

import Vapor
import Fluent

enum UserRole: String, Codable {
    
    static func prepareEnumMigration(database: FluentKit.Database) async throws -> FluentKit.DatabaseSchema.DataType {
        return try await database.enum("user_role")
            .case(Self.admin.rawValue)
            .case(Self.user.rawValue)
            .case(Self.guest.rawValue)
            .case(Self.unconfirmed.rawValue)
            .case(Self.unconfirmedAdmin.rawValue)
            .create()
    }

    static var registerName: String = "userRole"
    
    case admin, user, guest, unconfirmed, unconfirmedAdmin
    
    var needNewCode: Bool {
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

final class User: Model, Content {
    
    static let schema: String = "users"
    static var optionField: AnyKeyPath = \User.name
    static var registerName: String = "user"
 
    
    @ID()
    var id: UUID?
    
    @Timestamp(key: "deleted_at", on: .delete)
    var deletedAt: Date?
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?
    
    @Field(key: "name")
    var name: String

    @Field(key: "email")
    var email: String

    @Field(key: "password_hash")
    var passwordHash: String
    
    @Field(key: "user_role")
    var userRole: UserRole
    
    @OptionalField(key: "confirmation_code")
    var confirmationCode: String?
    
    @Timestamp(key: "confirmation_expire", on: .none)
    var expire: Date?
    
    @OptionalParent(key: "company_id")
    var company: Company?
    
    @Siblings(through: UserCompanyRelation.self, from: \.$user, to: \.$company)
    var companies: [Company]
    
    
    init() { }

    init(id: UUID? = nil, name: String, email: String, passwordHash: String, userRole: UserRole, confirmationCode: String?, expire: Date?, companyID: Company.IDValue?) {
        self.id = id
        self.name = name
        self.email = email
        self.passwordHash = passwordHash
        self.userRole = userRole
        self.confirmationCode = confirmationCode
        self.expire = expire
        self.$company.id = companyID
    }
}

extension User {
    
    static func generateCode() -> String { String(UInt32.random(in: 100000...999999)) }
    
    struct Create: Content {
        var name: String
        var email: String
        var password: String
        var confirmPassword: String
    }
    
    struct CreateCompanyOwner: Content {
        var name: String
        var email: String
        var password: String
        var confirmPassword: String
        var companyName: String
        var companyUIN: String
        var companyAddress: String
    }
    struct Confirm: Content {
        var email: String
        var code: String
    }
    struct Forgot: Content {
        var email: String
    }
    struct ResetPassword: Content {
        var email: String
        var code: String
        var password: String
        var confirmPassword: String
    }
}
extension User.Create: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("name", as: String.self, is: !.empty)
        validations.add("email", as: String.self, is: .email)
        validations.add("password", as: String.self, is: .count(8...))
    }
}

extension User.CreateCompanyOwner: Validatable {
    static func validations(_ validations: inout Validations) {
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
    static func validations(_ validations: inout Validations) {
        validations.add("email", as: String.self, is: .email)
        validations.add("code", as: String.self, is: .count(6...6))
    }
}

extension User: ModelAuthenticatable {
    static let usernameKey = \User.$email
    static let passwordHashKey = \User.$passwordHash

    func verify(password: String) throws -> Bool {
        print("[JORO] verify user")
        return try Bcrypt.verify(password, created: self.passwordHash)
    }
}
extension User: ModelSessionAuthenticatable { }
