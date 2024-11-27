//
//  Partner.swift
//  types-lib
//
//  Created by Georgie Ivanov on 27.11.24.
//

public protocol PartnerCodable: Codable {
    var name: String { get set }
    var uid: String? { get set }
    var address: String? { get set }
    var configuration: PartnerConfiguration? { get set }
}
