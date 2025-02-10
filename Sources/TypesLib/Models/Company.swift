//
//  Company.swift
//  types-lib
//
//  Created by Georgie Ivanov on 14.10.24.
//
import Vapor
import Fluent

public final class Company: Model, Content, @unchecked Sendable {

    public static let schema: String = "companies"
    
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

    @Field(key: "uid")
    public var uid: String

    @OptionalField(key: "address")
    public var address: String?
    
    @OptionalField(key: "database")
    public var database: String?
    
    @OptionalField(key: "configuration")
    public var configuration: CompanyConfiguration?
    
    @Field(key: "owner")
    public var owner: UUID
    
    @Siblings(through: UserCompanyRelation.self, from: \.$company, to: \.$user)
    public var users: [User]
    
    public var local: Bool = false
    
    @Field(key: "user_company_roles")
    public var currentUserCompanyRoles: [UserCompanyRole]

    public init() { }

    public init(id: UUID? = nil, name: String, uid: String, address: String, database db: String?, configuration c: CompanyConfiguration, owner o: UUID) {
        self.id = id
        self.name = name
        self.uid = uid
        self.address = address
        self.database = db
        self.configuration = c
        self.owner = o
    }
    
    public struct Create: Content {
        public let name: String
        public let uid: String
        public let address: String
        public let clientsAccount: Int?
        public let suppliersAccount: Int?
        public let bankCostsAccount: Int?
        public let cashAccount: Int?
        public let register: Int?
        public let bankAccounts: [BankAccount]
    }
    
    public struct Update: Content {
        public let id: UUID
        public let name: String
        public let uid: String
        public let address: String
        public let clientsAccount: Int?
        public let suppliersAccount: Int?
        public let bankCostsAccount: Int?
        public let cashAccount: Int?
        public let register: Int?
        public let bankAccounts: [BankAccount]
    }
    
    enum CodingKeys: String, CodingKey {
        case id, deletedAt, createdAt, updatedAt, name, uid, address, configuration, local, owner, currentUserCompanyRoles
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(deletedAt, forKey: .deletedAt)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(updatedAt, forKey: .updatedAt)
        try container.encode(name, forKey: .name)
        try container.encode(uid, forKey: .uid)
        try container.encode(address, forKey: .address)
        try container.encode(configuration, forKey: .configuration)
        try container.encode(local, forKey: .local)
        try container.encode(owner, forKey: .owner)
        try container.encode(currentUserCompanyRoles, forKey: .currentUserCompanyRoles)
    }
    
    public func setUserCompanyRoles(_ roles: [UserCompanyRole]) {
        self.currentUserCompanyRoles = roles
    }
    
    @Sendable
    public func getCompanies(req: Request) async throws -> [Company] {
        let user = try req.auth.require(User.self)
        let companies = try await Company.query(on: req.db)
            .fields(for: Company.self)
            .field(UserCompanyRelation.self, \UserCompanyRelation.$userCompanyRoles)
            .join(UserCompanyRelation.self, on: \UserCompanyRelation.$company.$id == \Company.$id)
            .filter(UserCompanyRelation.self, \UserCompanyRelation.$user.$id == user.requireID())
            .all()
        return try await req.auth.require(User.self).$companies.get(on: req.db)
    }
    
//    public func attachLocalCompany(user: User, on db: Database) async throws {
//        let relation = UserCompanyRelation(user: user, company: self)
//        try await relation.create(on: db)
//    }
//    
//    public func detachLocalCompany(user: User, on db: Database) async throws {
//        let relation = UserCompanyRelation(user: user, company: self)
//        try await relation.delete(force: true, on: db)
//    }
    
    public func changeOwner(to user: User, on db: Database) async throws {
        self.owner = try user.requireID()
        try await self.save(on: db)
    }
    
//    func delete(force: Bool = false, on database: any Database) async throws {
//        try await database.transaction { db in
//            try await UserCompanyRelation.query(on: db).filter(\UserCompanyRelation.$company.$id, .equal, self.requireID()).delete(force: true)
//            try await self.delete(force: force, on: db).get()
//        }
//        
//    }
}

extension Company.Create: Validatable {
    public static func validations(_ validations: inout Validations) {
        validations.add("name", as: String.self, is: !.empty)
        validations.add("uid", as: String.self, is: !.empty)
    }
}

extension Company.Update: Validatable {
    public static func validations(_ validations: inout Validations) {
        validations.add("id", as: UUID.self, is: .valid)
        validations.add("name", as: String.self, is: !.empty)
        validations.add("uid", as: String.self, is: !.empty)
    }
}

