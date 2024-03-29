//
//  File.swift
//  
//
//  Created by MacBook on 05.02.2024.
//

import Foundation

public struct ExchangeRate {
    public let source: Currency
    public let target: Currency
    public let rateValue: Decimal

    var pair: String {
        "\(source.code)\(target.code)"
    }

    public init(source: Currency, target: Currency, rateValue: Decimal) {
        self.source = source
        self.target = target
        self.rateValue = rateValue
    }
}
