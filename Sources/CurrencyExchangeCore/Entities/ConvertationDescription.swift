//
//  ConvertationDescription.swift
//  
//
//  Created by MacBook on 05.02.2024.
//

import Foundation

struct ConvertationDescription {
    let exchangeRate: ExchangeRate
    let originalAmount: Decimal
    let interest: Decimal

    var sourceToTargetRate: Decimal {
        exchangeRate.rateValue
    }
}
