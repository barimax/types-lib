//
//  PartnerConfiguration.swift
//  types-lib
//
//  Created by Georgie Ivanov on 27.11.24.
//

public protocol PartnerConfigurationProtocol: Codable {
    var bankAccounts: [BankAccount]? { get set }
}
