//
//  BankAccount.swift
//  types-lib
//
//  Created by Georgie Ivanov on 5.12.24.
//

import Vapor
import Fluent

public class BankAccount: PartnerBankAccountProtocol {
    
    public let bic: String?
    public let name: String
    public let iban: String
    public let currency: Currency
    public let bankAccount: Int
    public let clientsAccount: Int?
    public let suppliersAccount: Int?
    public let bankCostsAccount: Int?
    public let bankCostsSearch: String?
    public let cashAccount: Int?
    public let cashSearch: String?
    public let register: Int?
    public let accountCriteria: [BankAccount.AccountCriteria]?
    public let accountDetails: BankAccount.AccountDetails?
    
    public init(bic: String?, name: String, iban: String, currency: Currency, bankAccount: Int, clientsAccount: Int?, suppliersAccount: Int?, bankCostsAccount: Int?, bankCostsSearch: String?, cashAccount: Int?, cashSearch: String?, register: Int?, accountCriteria: [BankAccount.AccountCriteria]?, accountDetails: BankAccount.AccountDetails?) {
        self.bic = bic
        self.name = name
        self.iban = iban
        self.currency = currency
        self.bankAccount = bankAccount
        self.clientsAccount = clientsAccount
        self.suppliersAccount = suppliersAccount
        self.bankCostsAccount = bankCostsAccount
        self.bankCostsSearch = bankCostsSearch
        self.cashAccount = cashAccount
        self.cashSearch = cashSearch
        self.register = register
        self.accountCriteria = accountCriteria
        self.accountDetails = accountDetails
    }
    
//    public struct Create: Content {
//        let iban: String
//        let currency: Currency
//        let bankAccount: Int
//        let clientsAccount: Int?
//        let suppliersAccount: Int?
//        let bankCostsAccount: Int?
//        let bankCostsSearch: String?
//        let cashAccount: Int?
//        let cashSearch: String?
//        let register: Int?
//        let accountCriteria: [BankAccount.AccountCriteria]?
//        let accountDetails: BankAccount.AccountDetails?
//    }
//    
//    public struct Update: Content {
//        let id: UUID
//        let iban: String
//        let currency: Currency
//        let bankAccount: Int
//        let clientsAccount: Int?
//        let suppliersAccount: Int?
//        let bankCostsAccount: Int?
//        let bankCostsSearch: String?
//        let cashAccount: Int?
//        let cashSearch: String?
//        let register: Int?
//        let accountCriteria: [BankAccount.AccountCriteria]?
//        let accountDetails: BankAccount.AccountDetails?
//    }
    
    public struct AccountCriteria: Codable, Sendable {
        let account:  Int
        let search: String?
        let isPartner: Bool
    }

    public struct AccountDetails: Codable, Sendable {
        let isSingleColumn: Bool
        let isNegativeColumn: Bool
        let singleColumn: String?
        let additionalColumn: String?
        let debitColumn: String?
        let creditColumn: String?
        let debitText: String?
        let creditText: String?
        let dateColumn: String?
        let dateFormat: String?
    }

}
extension BankAccount: Validatable {
    public static func validations(_ validations: inout Validations) {
        validations.add("iban", as: String.self, is: !.empty)
        validations.add("name", as: String.self, is: !.empty)
    }
}


