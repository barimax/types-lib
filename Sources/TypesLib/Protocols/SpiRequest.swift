//
//  HiddenUser.swift
//  types-lib
//
//  Created by Georgie Ivanov on 7.02.25.
//
import Vapor
import Fluent

public protocol SpiRequest where Self: Request {
    func user() async throws -> User
}
public extension SpiRequest {
    func user() async throws -> User {
        guard let userIDString = self.headers.first(name: "X-auth-user-id"),
              let token = self.headers.bearerAuthorization?.token,
              let url = (self.application as? SpiApplication)?.spiFullURLString else {
            throw Abort(.unauthorized)
        }
        
        let userResponse = try await self.client.get(
            "\(url)/spi/user/get/\(userIDString)",
            headers: [
                "Authorization": "Bearer \(token)",
                "Content-Type": "application/json",
            ]
        )
        self.application.logger.debug("User: \(userResponse)")
        let user = try userResponse.content.decode(User.self)
        return user
    }
}
