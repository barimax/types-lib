//
//  AppConfig.swift
//  types-lib
//
//  Created by Georgie Ivanov on 8.12.25.
//
import FluentMySQLDriver
import NIOFileSystem
import NIOSSL
import Vapor
import WebAuthn

public struct ReadError: Error {
    let reason: String
}

public struct AppConfig: Decodable, Sendable {
    let dbHost: String
    let dbUser: String
    let dbPassword: String
    let dbName: String
    let smtpHost: String
    let smtpUser: String
    let smtpPassword: String
    let jwtSecret: String
    let relyingPartyID: String // "your-domain.com"
    let relyingPartyName: String // "Your App Name"
    let relyingPartyOrigin: String // "https://your-domain.com"
    
    public static var tls: TLSConfiguration {
        var tls = TLSConfiguration.makeClientConfiguration()
        tls.certificateVerification = .none
        return tls
    }
    
    public static func load() async throws -> AppConfig {
        var configByteBuffer = try await ByteBuffer(
            contentsOf: "config.json",
            maximumSizeAllowed: .mebibytes(1)
        )
        guard let configData = configByteBuffer.readData(length: configByteBuffer.readableBytes, byteTransferStrategy: .automatic) else {
            throw ReadError(reason: "Can't read config.json")
        }
        guard let appConfig = try? JSONDecoder().decode(AppConfig.self, from: configData) else {
            throw ReadError(reason: "Can't decode config.json")
        }
        return appConfig
    }
}
