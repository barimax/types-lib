//
//  RequestExtension.swift
//  types-lib
//
//  Created by Georgie Ivanov on 9.02.25.
//

import Vapor
import Fluent
import WebAuthn

public extension Request {
    var authServer: AuthServer {
        AuthServer(request: self)
    }
}

public class AuthServer {
    let request: Request
    
    init(request: Request) {
        self.request = request
    }
    
    public func jwtVerify() throws -> HTTPStatus {
        let _ = try getJWTPayload()
        return .ok
    }
    
    public func getJWTPayload() throws -> User.JWTToken {
        try request.auth.require(User.JWTToken.self)
    }
    
    public func requestUser() async throws -> User {
        guard let spiHost = request.headers.first(name: "X-spi-host"),
              let token = request.headers.bearerAuthorization?.token else {
            throw Abort(.badRequest, reason: "Missing X-spi-host header.")
        }
        
        let userResponse = try await request.client.get(
            "http://\(spiHost)/auth/user",
            headers: [
                "Authorization": "Bearer \(token)",
                "Content-Type": "application/json",
            ]
        )
        request.application.logger.debug("User: \(userResponse)")
        let user = try userResponse.content.decode(User.self)
        return user
    }
    
    
    public func listCompanies() async throws -> [Company] {
        guard let spiHost = request.headers.first(name: "X-spi-host"),
              let appType = request.headers.first(name: "X-app-type"),
              let token = request.headers.bearerAuthorization?.token else {
            throw Abort(.unauthorized)
        }
        
        let userResponse = try await request.client.get(
            "http://\(spiHost)/auth/company",
            headers: [
                "Authorization": "Bearer \(token)",
                "Content-Type": "application/json",
                "X-app-type": appType,
            ]
            )
        return try userResponse.content.decode([Company].self)
    }
    
    public func getCompany(id: UUID) async throws -> Company {
        guard let spiHost = request.headers.first(name: "X-spi-host"),
              let appType = request.headers.first(name: "X-app-type"),
              let token = request.headers.bearerAuthorization?.token else {
            throw Abort(.unauthorized)
        }
        
        let userResponse = try await request.client.get(
            "http://\(spiHost)/auth/company/\(id)",
            headers: [
                "Authorization": "Bearer \(token)",
                "Content-Type": "application/json",
                "X-app-type": appType,
            ]
            )
        return try userResponse.content.decode(Company.self)
    }
    
    public func requireUserId() throws -> UUID {
        let jwtToken = try getJWTPayload()
        return jwtToken.userId
    }
    
    
    public var companyDatabaseID: String? {
        request.headers.first(name: "X-company-database")
    }
    
    public var companyID: String? {
        request.headers.first(name: "X-company-id")
    }
    
    // BusinessType is important to load in menu models needed
    public var businessType: BusinessType {
        guard let businessTypeString = request.headers.first(name: "X-business-type"),
              let businessType = BusinessType(rawValue: businessTypeString) else {
            return .none
        }
        return businessType
    }
}
