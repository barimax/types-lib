//
//  BankAccountProtocol.swift
//  types-lib
//
//  Created by Georgie Ivanov on 27.11.24.
//

public protocol PartnerBankAccountProtocol: Codable, Sendable {
    var bic: String? { get }
    var iban: String { get }
    var name: String { get }
}
