//
//  CurrencyConverter.swift
//  
//
//  Created by MacBook on 08.02.2024.
//

import Foundation

public enum CurrencyConverterError: Error {
    case dataSourceDoesNotContain(String)
}

public struct CurrencyConverter {
    enum InterstMode {
        case subsctract
        case add
    }

    private let baseCurrency: String
    private let dataSource: ExchangeRateDataSource
    private let convertationModel: ConvertationModel

    public init(
        dataSource: ExchangeRateDataSource,
        baseCurrency: String
    ) {
        self.dataSource = dataSource
        self.baseCurrency = baseCurrency
        self.convertationModel = ConvertationModelImpl()
    }

    public func convert(source: String, target: String, amount: Decimal, interest: Decimal) throws -> Decimal {
        if source != baseCurrency {
            return try calculateAsCrossCurrency(source: source, target: target, amount: amount, interest: interest)
        }

        if target != baseCurrency, let pairRate = try dataSource.retrieve(pair: "\(baseCurrency)\(target)") {
            let convrtationDescription = ConvertationDescription(
                exchangeRate: pairRate,
                originalAmount: amount,
                interest: interest
            )
            return try convertationModel.execute(convertation: convrtationDescription)
        }
        return try calculateAsCrossCurrency(source: source, target: target, amount: amount, interest: interest)
    }

    private func calculateAsCrossCurrency(
        source: String,
        target: String,
        amount: Decimal,
        interest: Decimal
    ) throws -> Decimal {
        let convrtationDescription = ConvertationDescription(
            exchangeRate: try getExchangeRate(source: source, target: target),
            originalAmount: amount,
            interest: interest
        )

        return try convertationModel.execute(convertation: convrtationDescription)
    }

    public func getExchangeRate(source: String, target: String) throws -> ExchangeRate {
        guard let sourcePair = try dataSource.retrieve(pair: "\(baseCurrency)\(source)") else {
            throw CurrencyConverterError.dataSourceDoesNotContain("\(baseCurrency)\(source)")
        }

        guard let targetPair = try dataSource.retrieve(pair: "\(baseCurrency)\(target)") else {
            throw CurrencyConverterError.dataSourceDoesNotContain("\(target)\(baseCurrency)")
        }

        let crossRateCalculator = CrossRateCalculatorImpl(sourcePair: sourcePair, targetPair: targetPair)

        return crossRateCalculator.exchangeRate()
    }
}
