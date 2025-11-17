//
//  RequestExtension.swift
//  types-lib
//
//  Created by Georgie Ivanov on 9.02.25.
//

import Vapor
import Fluent

public extension Request {
    func authUser(token: String) async throws -> User {
        guard let spiHost = self.headers.first(name: "X-spi-host") else {
            throw Abort(.unauthorized)
        }
        let userResponse = try await self.client.get(
            "http://\(spiHost)/spi/user/auth/",
            headers: [
                "Authorization": "Bearer \(token)",
                "Content-Type": "application/json",
            ]
        )
        self.application.logger.debug("User: \(userResponse)")
        let user = try userResponse.content.decode(User.self)
        return user
    }
    func user() async throws -> User {
        guard let spiHost = self.headers.first(name: "X-spi-host"),
              let userIDString = self.headers.first(name: "X-auth-user-id"),
              let token = self.headers.bearerAuthorization?.token else {
            throw Abort(.unauthorized)
        }
        
        let userResponse = try await self.client.get(
            "http://\(spiHost)/spi/user/get/\(userIDString)",
            headers: [
                "Authorization": "Bearer \(token)",
                "Content-Type": "application/json",
            ]
        )
        self.application.logger.debug("User: \(userResponse)")
        let user = try userResponse.content.decode(User.self)
        return user
    }
    
    func listCompanies() async throws -> [Company] {
        guard let spiHost = self.headers.first(name: "X-spi-host"),
              let token = self.headers.bearerAuthorization?.token else {
            throw Abort(.unauthorized)
        }
        
        let userResponse = try await self.client.get(
            "http://\(spiHost)/spi/company/get",
            headers: [
                "Authorization": "Bearer \(token)",
                "Content-Type": "application/json",
            ]
            )
        return try userResponse.content.decode([Company].self)
    }
    
    func getCompany(id: UUID) async throws -> Company {
        guard let spiHost = self.headers.first(name: "X-spi-host"),
              let token = self.headers.bearerAuthorization?.token else {
            throw Abort(.unauthorized)
        }
        
        let userResponse = try await self.client.get(
            "http://\(spiHost)/spi/company/get/\(id)",
            headers: [
                "Authorization": "Bearer \(token)",
                "Content-Type": "application/json",
            ]
            )
        return try userResponse.content.decode(Company.self)
    }
    
    var userID: UUID? {
        guard let userIDString = self.headers.first(name: "X-auth-user-id"),
              let userUUID = UUID(uuidString: userIDString) else {
            return nil
        }
        return userUUID
    }
    var companyDatabaseID: String? {
        self.headers.first(name: "X-company-database")
    }
    var companyID: String? {
        self.headers.first(name: "X-company-id")
    }
    
    // BusinessType is important to load in menu models needed
    var businessType: BusinessType? {
        guard let businessTypeString = self.headers.first(name: "X-business-type"),
              let businessType = BusinessType(rawValue: businessTypeString) else {
            return nil
        }
        return businessType
    }
}
