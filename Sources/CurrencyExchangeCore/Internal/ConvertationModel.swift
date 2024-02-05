//
//  ConvertationModel.swift
//  
//
//  Created by MacBook on 05.02.2024.
//

import Foundation

enum ConvertationModelError: Error {
    case rateIsLessThanZero
}

protocol ConvertationModel {
    func execute(convertation: ConvertationDescription) throws -> Decimal
}

struct ConvertationModelImpl: ConvertationModel {
    func execute(convertation: ConvertationDescription) throws -> Decimal {
        if convertation.sourceToTargetRate.isLess(than: 0) {
            throw ConvertationModelError.rateIsLessThanZero
        }
        
        let originalConvertation = convertation.originalAmount * convertation.sourceToTargetRate
        let percentValue: Decimal = convertation.interest / 100
        return originalConvertation + (originalConvertation * percentValue)
    }
}
