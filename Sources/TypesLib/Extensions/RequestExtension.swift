//
//  RequestExtension.swift
//  types-lib
//
//  Created by Georgie Ivanov on 9.02.25.
//

import Vapor
import Fluent

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
    
    
    func listCompanies() async throws -> [Company] {
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
    
    func getCompany(id: UUID) async throws -> Company {
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
    
    func requireUserId() throws -> UUID {
        let jwtToken = try getJWTPayload()
        return jwtToken.userId
    }
    
    @available(*, deprecated)
    var companyDatabaseID: String? {
        request.headers.first(name: "X-company-database")
    }
    @available(*, deprecated)
    var companyID: String? {
        request.headers.first(name: "X-company-id")
    }
    
    // BusinessType is important to load in menu models needed
    @available(*, deprecated)
    var businessType: BusinessType? {
        guard let businessTypeString = request.headers.first(name: "X-business-type"),
              let businessType = BusinessType(rawValue: businessTypeString) else {
            return nil
        }
        return businessType
    }
}
