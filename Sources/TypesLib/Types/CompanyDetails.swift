//
//  CompanyDetails.swift
//  types-lib
//
//  Created by Georgie Ivanov on 20.10.24.
//

class ComapnyDetails: Codable {
    let billingCity: String
    let billingAddress: String
    let shippingCity: String
    let shippingAddress: String
    let hasVAT: Bool
    let mol: String?
    
    init(
        billingCity bc: String,
        billingAddress ba: String,
        shippingCity sc: String? = nil,
        shippingAddress sa: String? = nil,
        hasVAT hv: Bool = true,
        mol m: String? = nil
    ){
        self.billingAddress = ba
        self.billingCity = bc
        self.hasVAT = hv
        self.shippingCity = sc ?? bc
        self.shippingAddress = sa ?? ba
        self.mol = m
    }
}
