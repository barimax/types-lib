//
//  CompanyConfiguration.swift
//  types-lib
//
//  Created by Georgie Ivanov on 18.11.24.
//

public struct CompanyConfiguration: Codable {
    public var clientsAccount: Int?
    public var suppliersAccount: Int?
    public var bankCostsAccount: Int?
    public var cashAccount: Int?
    public var taxAccount: Int?
    public var register: Int?
    public var bankAccounts: [BankAccount]?
    
    public init(clientsAccount: Int? = nil, suppliersAccount: Int? = nil, bankCostsAccount: Int? = nil, cashAccount: Int? = nil, taxAccount: Int? = nil, register: Int? = nil, bankAccounts: [BankAccount]? = nil) {
        self.clientsAccount = clientsAccount
        self.suppliersAccount = suppliersAccount
        self.bankCostsAccount = bankCostsAccount
        self.cashAccount = cashAccount
        self.taxAccount = taxAccount
        self.register = register
        self.bankAccounts = bankAccounts
    }
}
