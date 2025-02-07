//
//  UserMiddleware.swift
//  types-lib
//
//  Created by Georgie Ivanov on 7.02.25.
//

import Vapor
import Fluent

//struct RequestDBMiddleware: AsyncMiddleware {
//    func respond(to request: Vapor.Request, chainingTo next: Vapor.AsyncResponder) async throws -> Vapor.Response {
//        let user = try request.auth.require(User.self)
//        let company = try await Company.query(on: request.db).filter(\Company.$owner == user.requireID()).first()
//        
//        var tls = TLSConfiguration.makeClientConfiguration()
//        tls.certificateVerification = .none
//        if let databaseID = company?.database {
//            request.databaseID = DatabaseID(string: databaseID)
//        }
//        return try await next.respond(to: request)
//    }
//}
