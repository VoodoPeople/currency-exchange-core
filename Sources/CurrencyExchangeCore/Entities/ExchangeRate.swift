//
//  File.swift
//  
//
//  Created by MacBook on 05.02.2024.
//

import Foundation

public struct ExchangeRate {
    let source: Currency
    let target: Currency
    let rateValue: Decimal

    var pair: String {
        "\(source.code)\(target.code)"
    }

    init(source: Currency, target: Currency, rateValue: Decimal) {
        self.source = source
        self.target = target
        self.rateValue = rateValue
    }
}
