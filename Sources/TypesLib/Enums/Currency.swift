//
//  Curremcy.swift
//  types-lib
//
//  Created by Georgie Ivanov on 4.12.24.
//

public enum Currency: Codable, Sendable {
    case bgn, eur, usd
}

public extension Double {
    func formatted(currency c: Currency) -> String {
        ""
    }
}
