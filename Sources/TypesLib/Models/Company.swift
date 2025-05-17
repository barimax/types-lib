//
//  Company.swift
//  types-lib
//
//  Created by Georgie Ivanov on 14.10.24.
//
import Vapor
import Fluent
import FluentSQL

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
    
//    @FieldProperty<UserCompanyRelation, [UserCompanyRole]>(key: "current_user_company_roles")
    public var currentUserCompanyRoles: [UserCompanyRole]?

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
        public let taxAccount: Int?
        public let refundAccount: Int?
        public let register: String?
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
        public let taxAccount: Int?
        public let refundAccount: Int?
        public let register: String?
        public let bankAccounts: [BankAccount]
    }
    
    enum CodingKeys: String, CodingKey {
        case id, deletedAt, createdAt, updatedAt, name, uid, address, configuration, local, owner, currentUserCompanyRoles, database
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
        try container.encode(database, forKey: .database)
        try container.encode(currentUserCompanyRoles, forKey: .currentUserCompanyRoles)
    }
    
    @Sendable
    public static func getCompanies(req: Request) async throws -> [Company] {
        let user = try req.auth.require(User.self)
        let companies = try await Company.query(on: req.db)
            .join(UserCompanyRelation.self, on: \UserCompanyRelation.$company.$id == \Company.$id)
            .filter(UserCompanyRelation.self, \UserCompanyRelation.$user.$id == user.requireID())
            .all()
        for c in companies {
            c.currentUserCompanyRoles = try c.joined(UserCompanyRelation.self).userCompanyRoles
            c.local = c.owner == user.id
        }
        return companies
    }
    
    @Sendable
    public static func getCompany(req: Request) async throws -> Company {
        guard let user = try? req.auth.require(User.self),
              let companyId = req.parameters.get("companyID"),
              let companyUUID = UUID(uuidString: companyId) else {
            throw Abort(.notFound)
        }
        guard let company = try await Company.find(companyUUID, on: req.db) else {
            throw Abort(.notFound)
        }
        company.currentUserCompanyRoles = try company.joined(UserCompanyRelation.self).userCompanyRoles
        company.local = company.owner == user.id
        return company
    }
    
    @Sendable
    public static func update(req: Request) async throws -> Company {
        try Company.Update.validate(content: req)
        let user: User = try req.auth.require(User.self)
        let update = try req.content.decode(Company.Update.self)
        let companyConfiguration = CompanyConfiguration(
            clientsAccount: update.clientsAccount,
            suppliersAccount: update.suppliersAccount,
            bankCostsAccount: update.bankCostsAccount,
            cashAccount: update.cashAccount,
            taxAccount: update.taxAccount,
            refundAccount: update.refundAccount,
            register: update.register,
            bankAccounts: update.bankAccounts.map { bankAccount in
                .init(
                    bic: bankAccount.bic,
                    name: bankAccount.name,
                    iban: bankAccount.iban,
                    currency: bankAccount.currency,
                    bankAccount: bankAccount.bankAccount,
                    taxAccount: bankAccount.taxAccount,
                    clientsAccount: bankAccount.clientsAccount ?? update.clientsAccount,
                    suppliersAccount: bankAccount.suppliersAccount ?? update.suppliersAccount,
                    bankCostsAccount: bankAccount.bankCostsAccount ?? update.bankCostsAccount,
                    bankCostsSearch: bankAccount.bankCostsSearch,
                    cashAccount: bankAccount.cashAccount ?? update.cashAccount,
                    cashSearch: bankAccount.cashSearch,
                    refundAccount: bankAccount.refundAccount ?? update.refundAccount,
                    refundSearch: bankAccount.refundSearch,
                    register: bankAccount.register ?? update.register,
                    accountCriteria: bankAccount.accountCriteria,
                    accountDetails: bankAccount.accountDetails
                )
                
            }
        )
        guard let userUUID = try? user.requireID() else {
            throw Abort(.internalServerError)
        }
        let optionalCompany = try await Company.query(on: req.db)
            .join(UserCompanyRelation.self, on: \UserCompanyRelation.$company.$id == \Company.$id)
            .filter(UserCompanyRelation.self, \UserCompanyRelation.$user.$id, .equal, userUUID)
            .filter(\Company.$id == update.id)
            .first()
        guard let company = optionalCompany else {
            throw Abort(.notFound, reason: "No company found.")
        }
        company.name = update.name
        company.uid = update.uid
        company.address = update.address
        company.configuration = companyConfiguration
        company.local = company.owner == userUUID
        try await company.update(on: req.db)
        return company
    }
    
    @Sendable
    public static func create(req: Request) async throws -> Company {
        req.logger.info("Create company begin...")
        
        // Auth user and get new company data
        let user = try req.auth.require(User.self)
        guard let userID = user.id else {
            throw Abort(.unauthorized)
        }
        let createCompany = try req.content.decode(Company.Create.self)
        req.logger.debug(.init(stringLiteral: String(describing: createCompany)))
        // Check if company exists for current user
        guard try await Company.query(on: req.db)
            .join(UserCompanyRelation.self, on: \UserCompanyRelation.$company.$id == \Company.$id)
            .filter(\Company.$uid, .equal, createCompany.uid)
//            .filter(UserCompanyRelation.self, \UserCompanyRelation.$user.$id == user.requireID())
            .first() == nil else {
            throw Abort(.forbidden, reason: "Фирмата съществува")
        }
        // Create new database name
        let dbName: String = String(abs((createCompany.uid+userID.uuidString).hash), radix: 16, uppercase: false)
        guard let sql = req.db as? SQLDatabase else {
            throw Abort(.internalServerError, reason: "NoSQLDatabase.")
        }
        req.logger.debug(.init(stringLiteral: "Creating database \(dbName)..."))
        do {
            try await sql.raw("CREATE DATABASE \"\(unsafeRaw: dbName)\"").run()
        } catch {
            req.logger.error(.init(stringLiteral: String(describing: error)))
            throw error
        }
        req.logger.debug(.init(stringLiteral: "Database \(dbName) created."))
        let companyConfiguration = CompanyConfiguration(
            clientsAccount: createCompany.clientsAccount,
            suppliersAccount: createCompany.suppliersAccount,
            bankCostsAccount: createCompany.bankCostsAccount,
            cashAccount: createCompany.cashAccount,
            taxAccount: createCompany.taxAccount,
            refundAccount: createCompany.refundAccount,
            register: createCompany.register,
            bankAccounts: createCompany.bankAccounts.map { bankAccount in
                    .init(
                        bic: bankAccount.bic,
                        name: bankAccount.name,
                        iban: bankAccount.iban,
                        currency: bankAccount.currency,
                        bankAccount: bankAccount.bankAccount,
                        taxAccount: bankAccount.taxAccount,
                        clientsAccount: bankAccount.clientsAccount ?? createCompany.clientsAccount,
                        suppliersAccount: bankAccount.suppliersAccount ?? createCompany.suppliersAccount,
                        bankCostsAccount: bankAccount.bankCostsAccount ?? createCompany.bankCostsAccount,
                        bankCostsSearch: bankAccount.bankCostsSearch,
                        cashAccount: bankAccount.cashAccount ?? createCompany.cashAccount,
                        cashSearch: bankAccount.cashSearch,
                        refundAccount: bankAccount.refundAccount ?? createCompany.refundAccount,
                        refundSearch: bankAccount.refundSearch,
                        register: bankAccount.register ?? createCompany.register,
                        accountCriteria: bankAccount.accountCriteria,
                        accountDetails: bankAccount.accountDetails
                    )
                    
                }
        )
        let company = Company(
            name: createCompany.name,
            uid: createCompany.uid,
            address: createCompany.address,
            database: dbName,
            configuration: companyConfiguration,
            owner: try user.requireID()
        )
        company.local = true
//        company.currentUserCompanyRoles = UserCompanyRole.owner
        req.logger.debug(.init(stringLiteral: "Saving \(company.name) to database..."))
        do {
            try await req.db.transaction { db async throws in
                try await company.create(on: db)
                try await company.$users.attach(user, on: db) { relation in
                    relation.userCompanyRoles = UserCompanyRole.owner
                }
            }
        } catch {
            req.logger.error(.init(stringLiteral: String(describing: error)))
            req.logger.debug(.init(stringLiteral: "Delete database \(dbName)..."))
            guard (try? await sql.raw("DROP DATABASE \(unsafeRaw: dbName)").run()) != nil else {
                req.logger.error(.init(stringLiteral: String(describing: error)))
                throw Abort(.internalServerError, reason: "Reverting database creation failed.")
            }
            throw error
        }
        req.logger.debug(.init(stringLiteral: "Database \(company.name) saved."))
        // Check database receiver instance IP and try attach database
        do {
            guard let proxyHost = req.headers.first(name: "X-proxy-host") else {
                throw Abort(.internalServerError, reason: "X-proxy-host header not found.")
            }
            guard try await req.client.post("http://\(proxyHost)/spi/setNewDatabase/\(dbName)").status == .ok else {
                throw Abort(.internalServerError, reason: "setNewDatabase failed.")
            }
        }catch {
            req.logger.error(.init(stringLiteral: String(describing: error)))
            req.logger.debug(.init(stringLiteral: "Reverting..."))
            
            guard (try? await company.$users.detach(user, on: req.db)) != nil,
                  (try? await company.delete(force: true, on: req.db)) != nil,
                  (try? await sql.raw("DROP DATABASE \(unsafeRaw: dbName)").run()) != nil else {
                req.logger.error(.init(stringLiteral: String(describing: error)))
                throw Abort(.internalServerError, reason: "Reverting company creation failed.")
            }
            req.logger.debug(.init(stringLiteral: "Reverting company creation completed successfully."))
            throw error
        }
        req.logger.info(.init(stringLiteral: "Company created successfully."))
        return company
    }
    
    @Sendable
    public func delete(req: Request) async throws -> HTTPStatus {
        let user = try req.auth.require(User.self)
        guard let companyIDString = req.parameters.get("companyID"),
              let companyID = UUID(uuidString: companyIDString),
              let company = try await Company.find(companyID, on: req.db),
              let dbName = company.database else {
            throw Abort(.badRequest)
        }
        try await req.db.transaction { db async throws in
            try await company.$users.detach(user, on: db)
            try await company.delete(on: req.db)
        }
        
        do {
            guard let sql = req.db as? SQLDatabase else {
                throw Abort(.internalServerError, reason: "NoSQLDatabase.")
            }
            req.logger.debug(.init(stringLiteral: "Deleting database \(dbName)..."))
            do {
                try await sql.raw("DROP DATABASE \(unsafeRaw: dbName)").run()
            } catch {
                req.logger.error(.init(stringLiteral: String(describing: error)))
                throw error
            }
        }catch{
            try await req.db.transaction { db async throws in
                try await company.restore(on: req.db)
                try await company.$users.attach(user, on: db)
            }
            
            req.logger.error(.init(stringLiteral: String(describing: error)))
            throw error
        }
        try await company.delete(force: true, on: req.db)
        return .ok
    }
    
    public func changeOwner(to user: User, on db: Database) async throws {
        self.owner = try user.requireID()
        try await self.save(on: db)
    }
    
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

