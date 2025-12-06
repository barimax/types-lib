//
//  CompanyConfiguration.swift
//  types-lib
//
//  Created by Georgie Ivanov on 18.11.24.
//

public struct CompanyConfiguration: Codable, Sendable {
    public var clientsAccount: Int?
    public var suppliersAccount: Int?
    public var bankCostsAccount: Int?
    public var cashAccount: Int?
    public var taxAccount: Int?
    public var refundAccount: Int?
    public var register: String?
    public var bankAccounts: [BankAccount]?
    
    public init(clientsAccount: Int? = nil, suppliersAccount: Int? = nil, bankCostsAccount: Int? = nil, cashAccount: Int? = nil, taxAccount: Int? = nil, refundAccount: Int? = nil, register: String? = nil, bankAccounts: [BankAccount]? = nil) {
        self.clientsAccount = clientsAccount
        self.suppliersAccount = suppliersAccount
        self.bankCostsAccount = bankCostsAccount
        self.cashAccount = cashAccount
        self.taxAccount = taxAccount
        self.refundAccount = refundAccount
        self.register = register
        self.bankAccounts = bankAccounts
    }
}
