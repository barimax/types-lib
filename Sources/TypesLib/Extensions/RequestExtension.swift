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
    
    var webAuthn: WebAuthnManager  {
        get async throws {
            guard let appConfig = self.application.configuration else {
                throw Abort(.internalServerError, reason: "Missing app config")
            }
            return WebAuthnManager(
                configuration: WebAuthnManager.Configuration(
                    // For production, this should be your real domain (without scheme)
                    relyingPartyID: appConfig.relyingPartyID,
                    relyingPartyName: appConfig.relyingPartyName,
                    relyingPartyOrigin: appConfig.relyingPartyOrigin
                )
            )
        }
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
        let jwtToken = try getJWTPayload()
        guard let spiHost = request.headers.first(name: "X-spi-host"),
              let token = request.headers.bearerAuthorization?.token else {
            throw Abort(.badRequest, reason: "Missing X-spi-host header.")
        }
        
        let userResponse = try await request.client.get(
            "http://\(spiHost)/spi/user/get/\(jwtToken.userId.uuidString)",
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
              let token = request.headers.bearerAuthorization?.token else {
            throw Abort(.unauthorized)
        }
        
        let userResponse = try await request.client.get(
            "http://\(spiHost)/spi/company/get",
            headers: [
                "Authorization": "Bearer \(token)",
                "Content-Type": "application/json",
            ]
            )
        return try userResponse.content.decode([Company].self)
    }
    
    public func getCompany(id: UUID) async throws -> Company {
        guard let spiHost = request.headers.first(name: "X-spi-host"),
              let token = request.headers.bearerAuthorization?.token else {
            throw Abort(.unauthorized)
        }
        
        let userResponse = try await request.client.get(
            "http://\(spiHost)/spi/company/get/\(id)",
            headers: [
                "Authorization": "Bearer \(token)",
                "Content-Type": "application/json",
            ]
            )
        return try userResponse.content.decode(Company.self)
    }
    
    public func requireUserId() throws -> UUID {
        let jwtToken = try getJWTPayload()
        return jwtToken.userId
    }
    
    @available(*, deprecated)
    public var companyDatabaseID: String? {
        request.headers.first(name: "X-company-database")
    }
    @available(*, deprecated)
    public var companyID: String? {
        request.headers.first(name: "X-company-id")
    }
    
    // BusinessType is important to load in menu models needed
    @available(*, deprecated)
    public var businessType: BusinessType? {
        guard let businessTypeString = request.headers.first(name: "X-business-type"),
              let businessType = BusinessType(rawValue: businessTypeString) else {
            return nil
        }
        return businessType
    }
}
