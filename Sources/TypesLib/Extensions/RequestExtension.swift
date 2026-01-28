//
//  RequestExtension.swift
//  types-lib
//
//  Created by Georgie Ivanov on 9.02.25.
//

import Vapor
import Fluent
import WebAuthn
import JWTKit

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
    
    public func getJWKs() async throws -> JWKS {
        guard let spiHost = request.headers.first(name: "X-spi-host") else {
            throw Abort(.badRequest, reason: "Missing X-spi-host header in get JWKs request.")
        }
        let response = try await request.client.get("http://\(spiHost)/.well-known/jwks.json")
        return try response.content.decode(JWKS.self)
    }
    
    public func requireUserId() async throws -> UUID {
        guard let token = request.headers.bearerAuthorization?.token else {
            throw Abort(.unauthorized, reason: "Missing Authorization Bearer token.")
        }
        let jwks = try await getJWKs()
        let keys = JWTKeyCollection()
        try await keys.add(jwks: jwks)
        do {
            let jwtToken = try await keys.verify(token, as: User.JWTToken.self, iteratingKeys: true)
            return jwtToken.userId
        } catch {
            request.logger.error("JWT verify failed: \(String(reflecting: error))")
            throw Abort(.unauthorized, reason: "JWT verification failed: \(error)")
        }
//        let jwtToken = try await keys.verify(token, as: User.JWTToken.self, iteratingKeys: true)
//        return jwtToken.userId
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
