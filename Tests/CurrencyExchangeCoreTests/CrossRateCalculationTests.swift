//
//  RateBuilderTests.swift
//  
//
//  Created by MacBook on 06.02.2024.
//

import XCTest
@testable import CurrencyExchangeCore

final class CrossRateCalculationTests: XCTestCase {

    // Given BASE/EUR and BASE/AUD
    // Goal to calculate cross rata based on BASE based rates EUR/AUD
    func test_convertationModel_convertCurrency_calcThirdViaSource() throws {
        let exchangeRateBASEEUR = ExchangeRate(
            source: .init(code: "BASE"),
            target: .init(code: "EUR"),
            rateValue: 1.1
        )

        let exchangeRateBASEAUD = ExchangeRate(
            source: .init(code: "BASE"),
            target: .init(code: "AUD"),
            rateValue: 11
        )

        let sut: CrossRateCalculator = CrossRateCalculatorImpl(
            sourcePair: exchangeRateBASEEUR,
            targetPair: exchangeRateBASEAUD
        )

        // rate EUR/AUD
        XCTAssertEqual(sut.exchangeRate().rateValue, (1/1.1) * 11)
        XCTAssertEqual(sut.exchangeRate().source.code, "EUR")
        XCTAssertEqual(sut.exchangeRate().target.code, "AUD")
    }
}
