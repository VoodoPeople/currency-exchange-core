//
//  File.swift
//  
//
//  Created by MacBook on 06.02.2024.
//

import Foundation

protocol CrossRateCalculator {
   func exchangeRate() -> ExchangeRate
}

struct CrossRateCalculatorImpl: CrossRateCalculator {

    let sourcePair: ExchangeRate
    let targetPair: ExchangeRate

    init(sourcePair: ExchangeRate, targetPair: ExchangeRate) {
        self.sourcePair = sourcePair
        self.targetPair = targetPair
    }

    func exchangeRate() -> ExchangeRate {
        ExchangeRate(
            source: sourcePair.target,
            target: targetPair.target,
            rateValue: (1 / sourcePair.rateValue) * targetPair.rateValue
        )
    }
}
