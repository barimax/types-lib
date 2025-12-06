//
//  CurrencyCode.swift
//  shame
//
//  Created by Georgie Ivanov on 1.02.25.
//
import Fluent

public enum CurrencyCode: String, Codable, CaseIterable, Sendable {
    
    public static let registerName: String = "currency_code"
    
    case AED, AFN, ALL, AMD, ANG, AOA, ARS, AUD, AWG, AZN
    case BAM, BBD, BDT, BGN, BHD, BIF, BMD, BND, BOB, BRL, BSD, BTN, BWP, BYN, BZD
    case CAD, CDF, CHF, CLP, CNY, COP, CRC, CUP, CVE, CZK
    case DJF, DKK, DOP, DZD
    case EGP, ERN, ETB, EUR
    case FJD, FKP
    case GBP, GEL, GHS, GIP, GMD, GNF, GTQ, GYD
    case HKD, HNL, HRK, HTG, HUF
    case IDR, ILS, INR, IQD, IRR, ISK
    case JMD, JOD, JPY
    case KES, KGS, KHR, KMF, KPW, KRW, KWD, KYD, KZT
    case LAK, LBP, LKR, LRD, LSL, LYD
    case MAD, MDL, MGA, MKD, MMK, MNT, MOP, MRU, MUR, MVR, MWK, MXN, MYR, MZN
    case NAD, NGN, NIO, NOK, NPR, NZD
    case OMR
    case PAB, PEN, PGK, PHP, PKR, PLN, PYG
    case QAR
    case RON, RSD, RUB, RWF
    case SAR, SBD, SCR, SDG, SEK, SGD, SHP, SLL, SOS, SRD, SSP, STN, SYP, SZL
    case THB, TJS, TMT, TND, TOP, TRY, TTD, TWD, TZS
    case UAH, UGX, USD, UYU, UZS
    case VES, VND, VUV
    case WST
    case XAF, XCD, XOF, XPF
    case YER
    case ZAR, ZMW, ZWL
    case ZZZ
    // Encode to lowercase string
    public func encode(to encoder: any Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encode(rawValue.uppercased())
        }

        // Decode from lowercase string
    public init(from decoder: any Decoder) throws {
            let container = try decoder.singleValueContainer()
            let value = try container.decode(String.self).uppercased()
            guard let code = CurrencyCode(rawValue: value) else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid currency code: \(value)")
            }
            self = code
        }
    public func getName() -> String? {
        return self.rawValue
    }
    
    public static func prepareEnumMigration(database: any FluentKit.Database) async throws -> FluentKit.DatabaseSchema.DataType {
        return try await database.enum(Self.registerName)
            .case("AED").case("AFN").case("ALL").case("AMD").case("ANG")
                        .case("AOA").case("ARS").case("AUD").case("AWG").case("AZN")
                        .case("BAM").case("BBD").case("BDT").case("BGN").case("BHD")
                        .case("BIF").case("BMD").case("BND").case("BOB").case("BRL")
                        .case("BSD").case("BTN").case("BWP").case("BYN").case("BZD")
                        .case("CAD").case("CDF").case("CHF").case("CLP").case("CNY")
                        .case("COP").case("CRC").case("CUP").case("CVE").case("CZK")
                        .case("DJF").case("DKK").case("DOP").case("DZD")
                        .case("EGP").case("ERN").case("ETB").case("EUR")
                        .case("FJD").case("FKP").case("GBP").case("GEL").case("GHS")
                        .case("GIP").case("GMD").case("GNF").case("GTQ").case("GYD")
                        .case("HKD").case("HNL").case("HRK").case("HTG").case("HUF")
                        .case("IDR").case("ILS").case("INR").case("IQD").case("IRR")
                        .case("ISK").case("JMD").case("JOD").case("JPY")
                        .case("KES").case("KGS").case("KHR").case("KMF").case("KPW")
                        .case("KRW").case("KWD").case("KYD").case("KZT").case("LAK")
                        .case("LBP").case("LKR").case("LRD").case("LSL").case("LYD")
                        .case("MAD").case("MDL").case("MGA").case("MKD").case("MMK")
                        .case("MNT").case("MOP").case("MRU").case("MUR").case("MVR")
                        .case("MWK").case("MXN").case("MYR").case("MZN").case("NAD")
                        .case("NGN").case("NIO").case("NOK").case("NPR").case("NZD")
                        .case("OMR").case("PAB").case("PEN").case("PGK").case("PHP")
                        .case("PKR").case("PLN").case("PYG").case("QAR").case("RON")
                        .case("RSD").case("RUB").case("RWF").case("SAR").case("SBD")
                        .case("SCR").case("SDG").case("SEK").case("SGD").case("SHP")
                        .case("SLL").case("SOS").case("SRD").case("SSP").case("STN")
                        .case("SYP").case("SZL").case("THB").case("TJS").case("TMT")
                        .case("TND").case("TOP").case("TRY").case("TTD").case("TWD")
                        .case("TZS").case("UAH").case("UGX").case("USD").case("UYU")
                        .case("UZS").case("VES").case("VND").case("VUV").case("WST")
                        .case("XAF").case("XCD").case("XOF").case("XPF").case("YER")
                        .case("ZAR").case("ZMW").case("ZWL")
                        .create()
    }
}


public extension Double {
    func formatted(currency c: CurrencyCode) -> String {
        ""
    }
}
