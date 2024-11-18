//
//  BankAccount.swift
//  types-lib
//
//  Created by Georgie Ivanov on 18.11.24.
//

public struct BankAccount: Codable {
    let bankName: String
    let iban: String
    let bic: String?
    
    public init(bankName: String, iban: String, bic: String?) {
        self.bankName = bankName
        self.iban = iban
        self.bic = bic
    }
}
