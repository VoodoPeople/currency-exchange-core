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

    func convert(source: String, target: String, amount: Decimal, interest: Decimal) throws -> Decimal {
        if let pairRate = try dataSource.retrieve(pair: "\(source)\(target)") {
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
        guard let sourcePair = try dataSource.retrieve(pair: "\(baseCurrency)\(source)") else {
            throw CurrencyConverterError.dataSourceDoesNotContain("\(baseCurrency)\(source)")
        }

        guard let targetPair = try dataSource.retrieve(pair: "\(baseCurrency)\(target)") else {
            throw CurrencyConverterError.dataSourceDoesNotContain("\(target)\(baseCurrency)")
        }

        let crossRateCalculator = CrossRateCalculatorImpl(sourcePair: sourcePair, targetPair: targetPair)
        let convrtationDescription = ConvertationDescription(
            exchangeRate: crossRateCalculator.exchangeRate(),
            originalAmount: amount,
            interest: interest
        )

        return try convertationModel.execute(convertation: convrtationDescription)
    }
}
