//
//  File.swift
//  
//
//  Created by MacBook on 07.02.2024.
//

import XCTest
@testable import CurrencyExchangeCore

struct ExchangeRateRepositoryMock: ExchangeRateDataSource {
    private let values: [ExchangeRate]

    init(values: [ExchangeRate]) {
        self.values = values
    }

    func retrieve(pair: String) throws -> ExchangeRate? {
        values.first { rate in
            rate.pair == pair
        }
    }
}

class CurrencyConverterTests: XCTestCase {
    func test_currencyConverter_convertStraight() throws {
        let mockRates = mockRates()
        let dataSource = ExchangeRateRepositoryMock(values: mockRates)

        let sut = CurrencyConverter(dataSource: dataSource, baseCurrency: "BASE")
        let convertationResult = try sut.convert(source: "BASE", target: "C1", amount: 2.0, interest: 0.0)

        XCTAssertEqual(convertationResult, 2.4)
    }

    func test_currencyConverter_convertConvertWithViaBase() throws {
        let mockRates = mockRates()
        let interest: Decimal = 0.0
        let amount: Decimal = 2.0
        let dataSource = ExchangeRateRepositoryMock(values: mockRates)

        let sut = CurrencyConverter(dataSource: dataSource, baseCurrency: "BASE")
        let convertationResult = try sut.convert(source: "C1", target: "C2", amount: amount, interest: interest)
        let expectedRate: Decimal = (1 / 1.2) * 0.4
        let expectedResult: Decimal = amount * expectedRate

        XCTAssertEqual(convertationResult, expectedResult)
    }

    func test_currencyConverter_dataSourceDoNotContainsRate() throws {
        let mockRates: [ExchangeRate] = []
        let dataSource = ExchangeRateRepositoryMock(values: mockRates)

        let sut = CurrencyConverter(dataSource: dataSource, baseCurrency: "BASE")

        XCTAssertThrowsError(try sut.convert(source: "C1", target: "C2", amount: 2.0, interest: 0.0))
    }

    func test_currencyConverter_convertConvertCrossRateWithInterest() throws {
        let mockRates = mockRates()
        let interest: Decimal = 0.0
        let amount: Decimal = 2.0
        let dataSource = ExchangeRateRepositoryMock(values: mockRates)

        let sut = CurrencyConverter(dataSource: dataSource, baseCurrency: "BASE")
        let convertationResult = try sut.convert(source: "C1", target: "C2", amount: amount, interest: interest)

        let expectedRate: Decimal = (1 / 1.2) * 0.4
        let expectedResult: Decimal = amount * expectedRate + ( amount * expectedRate * interest/100)
        XCTAssertEqual(convertationResult, expectedResult)
    }

    private func mockRates() -> [ExchangeRate] {
        [
            ExchangeRate(
                source: .init(code: "BASE"),
                target: .init(code: "C1"),
                rateValue: 1.2
            ),
            ExchangeRate(
                source: .init(code: "BASE"),
                target: .init(code: "C2"),
                rateValue: 0.4
            )
        ]
    }
}
