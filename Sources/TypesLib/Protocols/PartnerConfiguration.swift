//
//  PartnerConfiguration.swift
//  types-lib
//
//  Created by Georgie Ivanov on 27.11.24.
//

public protocol PartnerConfigurationProtocol: Codable {
    associatedtype B: BankAccountProtocol
    var bankAccounts: [B]? { get set }
}
