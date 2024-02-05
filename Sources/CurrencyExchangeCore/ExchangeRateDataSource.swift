//
//  ExchangeRateDataSource.swift
//  
//
//  Created by MacBook on 08.02.2024.
//

import Foundation

public protocol ExchangeRateDataSource {
    func retrieve(pair: String) throws -> ExchangeRate?
}
