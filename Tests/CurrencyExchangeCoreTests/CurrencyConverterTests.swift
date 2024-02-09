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
    func test_currencyConverter_convertBaseTarget() throws {
        let mockRates = mockRates(BASEC1: 1, BASEC2: 2)
        let dataSource = ExchangeRateRepositoryMock(values: mockRates)

        let sut = CurrencyConverter(dataSource: dataSource, baseCurrency: "BASE")
        let convertationResult = try sut.convert(source: "BASE", target: "C1", amount: 2.0, interest: 0.0)

        XCTAssertEqual(convertationResult, 2)
    }

    func test_currencyConverter_convertInverseTargetToBase() throws {
        let mockRates = mockRates(BASEC1: 4, BASEC2: 2)
        let dataSource = ExchangeRateRepositoryMock(values: mockRates)

        let sut = CurrencyConverter(dataSource: dataSource, baseCurrency: "BASE")
        let convertationResult = try sut.convert(source: "C1", target: "BASE", amount: 2.0, interest: 0.0)

        XCTAssertEqual(convertationResult, 0.5)
    }

    func test_currencyConverter_convertConvertWithViaBase() throws {
        let mockRates = mockRates(BASEC1: 1, BASEC2: 2)
        let interest: Decimal = 0.0
        let amount: Decimal = 2.0
        let dataSource = ExchangeRateRepositoryMock(values: mockRates)

        let sut = CurrencyConverter(dataSource: dataSource, baseCurrency: "BASE")
        let convertationResult = try sut.convert(source: "C1", target: "C2", amount: amount, interest: interest)
        let expectedRate: Decimal = 2
        let expectedResult: Decimal = amount * expectedRate

        XCTAssertEqual(convertationResult, expectedResult)
    }

    func test_currencyConverter_dataSourceDoNotContainsRate() throws {
        let mockRates: [ExchangeRate] = []
        let dataSource = ExchangeRateRepositoryMock(values: mockRates)

        let sut = CurrencyConverter(dataSource: dataSource, baseCurrency: "BASE")

        XCTAssertThrowsError(try sut.convert(source: "C1", target: "C3", amount: 2.0, interest: 0.0))
    }

    func test_currencyConverter_convertConvertBASEC1() throws {
        let mockRates = mockRates(BASEC1: 5, BASEC2: 2)
        let interest: Decimal = 1.0
        let amount: Decimal = 2.0
        let dataSource = ExchangeRateRepositoryMock(values: mockRates)

        let sut = CurrencyConverter(dataSource: dataSource, baseCurrency: "BASE")
        let convertationResult = try sut.convert(source: "BASE", target: "C1", amount: amount, interest: interest)

        let expectedRate: Decimal = 5
        let expectedResult: Decimal = amount * expectedRate - ( amount * expectedRate * interest/100)
        XCTAssertEqual(convertationResult, expectedResult)
    }

    private func mockRates(BASEC1: Decimal, BASEC2: Decimal) -> [ExchangeRate] {
        [
            ExchangeRate(
                source: .init(code: "BASE"),
                target: .init(code: "C1"),
                rateValue: BASEC1
            ),
            ExchangeRate(
                source: .init(code: "BASE"),
                target: .init(code: "C2"),
                rateValue: BASEC2
            ),
            ExchangeRate(
                source: .init(code: "BASE"),
                target: .init(code: "BASE"),
                rateValue: 1
            )
        ]
    }
}
