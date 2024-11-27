//
//  BankAccountProtocol.swift
//  types-lib
//
//  Created by Georgie Ivanov on 27.11.24.
//

public protocol BankAccountProtocol: Codable {
    var bic: String? { get set }
    var iban: String { get set }
    var name: String { get set }
}
