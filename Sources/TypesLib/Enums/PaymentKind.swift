//
//  PaymentKind.swift
//  types-lib
//
//  Created by Georgie Ivanov on 19.05.25.
//
import Foundation

public enum PaymentKind: String, CaseIterable, Codable, Sendable {
    case none = "none"
    case fromClient = "from_client"
    case toSupplier = "to_supplier"
    case receivedOnPosByClient = "received_on_POS_by_client"
    case paidOnPosToSupplier = "paid_on_POS_to_supplier"
    case paidTax = "paid_tax"
    case undefinedInboundPaymentOnPos = "undefined_inbound_payment_on_pos"
    case undefinedOutboundPaymentOnPos = "undefined_outbound_payment_on_pos"
    case bankCosts = "bank_costs"
    case fromPerson = "inbound_from_person"
    case atmInbound = "inbound_on_atm"
    case atmOutbound = "outbound_on_atm"
    case fintechPayment = "fintech_payment"
    
    public enum CodingKeys: String, CodingKey {
        case none = "none"
        case fromClient = "from_client"
        case toSupplier = "to_supplier"
        case receivedOnPosByClient = "received_on_POS_by_client"
        case paidOnPosToSupplier = "paid_on_POS_to_supplier"
        case paidTax = "paid_tax"
        case undefinedInboundPaymentOnPos = "undefined_inbound_payment_on_pos"
        case undefinedOutboundPaymentOnPos = "undefined_outbound_payment_on_pos"
        case bankCosts = "bank_costs"
        case fromPerson = "inbound_from_person"
        case atmInbound = "inbound_on_atm"
        case atmOutbound = "outbound_on_atm"
        case fintechPayment = "fintech_payment"
    }
    
    public static var rawValues: [String] {
        PaymentKind.allCases.map { $0.rawValue }
    }
    
    public static var rawValuesEncoded: String? {
        try? String(data:JSONEncoder().encode(PaymentKind.rawValues), encoding: .utf8)
    }
}
