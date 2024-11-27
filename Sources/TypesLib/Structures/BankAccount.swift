//
//  BankAccount.swift
//  types-lib
//
//  Created by Georgie Ivanov on 18.11.24.
//

public struct BankAccount: BankAccountProtocol {
    public var name: String
    public var iban: String
    public var bic: String?
    
    public init(name: String, iban: String, bic: String?) {
        self.name = name
        self.iban = iban
        self.bic = bic
    }
}
