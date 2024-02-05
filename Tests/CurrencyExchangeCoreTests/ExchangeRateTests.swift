//
//  ExchangeRateTests.swift
//  
//
//  Created by MacBook on 06.02.2024.
//

import XCTest
@testable import CurrencyExchangeCore

final class ExchangeRateTests: XCTestCase {
    func test_exchangeRate_init_correctRate() {
        let sourceCurrency = Currency(code: "C1")
        let targetCurrency = Currency(code: "C2")

        let exchangeRate = ExchangeRate(source: sourceCurrency, target: targetCurrency, rateValue: 1.1)

        XCTAssertEqual(exchangeRate.rateValue, 1.1)
    }

    func test_exchangeRate_init_sourceCorrectCode() {
        let sourceCurrency = Currency(code: "C1")
        let targetCurrency = Currency(code: "C2")

        let exchangeRate = ExchangeRate(source: sourceCurrency, target: targetCurrency, rateValue: 1.1)

        XCTAssertEqual(exchangeRate.source.code, "C1")
    }

    func test_exchangeRate_init_targetCorrectCode() {
        let sourceCurrency = Currency(code: "C1")
        let targetCurrency = Currency(code: "C2")

        let exchangeRate = ExchangeRate(source: sourceCurrency, target: targetCurrency, rateValue: 1.1)

        XCTAssertEqual(exchangeRate.target.code, "C2")
    }
}
