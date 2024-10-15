//
//  AuthResponse.swift
//  types-lib
//
//  Created by Georgie Ivanov on 14.10.24.
//

import Vapor

struct AuthResponse: AsyncResponseEncodable, Content, Codable {
    func encodeResponse(for request: Vapor.Request) async throws -> Vapor.Response {
        do {
            let data = try Configuration.encoder.encode(self)
            return Response.init(status: .ok, headers: HTTPHeaders([("content-type","application/json")]), body: Response.Body.init(data: data))
        }catch{
            throw MyError.unconvirtible
        }
    }
    
    let token: String
    let companies: [Company]
    let user: User
    
    init(
        token: String,
        companies: [Company],
        user: User
    ) {
        self.token = token
        self.companies = companies
        self.user = user
    }
}
