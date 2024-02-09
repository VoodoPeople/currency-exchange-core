import XCTest
@testable import CurrencyExchangeCore

final class ConvertationModelTests: XCTestCase {
    func test_convertationModel_convertCurrency_sourceToTarget_withZeroInterestRate() throws {
        let exchangeRate = ExchangeRate(source: .init(code: "C1"), target: .init(code: "C2"), rateValue: 0.01)
        let description = ConvertationDescription(exchangeRate: exchangeRate, originalAmount: 1.0, interest: 0.0)

        let sut: ConvertationModel = ConvertationModelImpl()
        let result = try sut.execute(convertation: description)

        XCTAssertEqual(result, 0.01)
    }

    func test_convertationModel_convertCurrency_sourceToTargetWithInterest5() throws {
        let rate: Decimal = 1
        let amount: Decimal = 2
        let interest: Decimal = 5.0
        let exchangeRate = ExchangeRate(source: .init(code: "C1"), target: .init(code: "C2"), rateValue: rate)
        let description = ConvertationDescription(exchangeRate: exchangeRate, originalAmount: amount, interest: interest)

        let sut: ConvertationModel = ConvertationModelImpl()
        let result = try sut.execute(convertation: description)
        /*Give take  (+ or -)*/
        XCTAssertEqual(result, amount * rate - (amount * rate * (interest / 100)))
    }

    func test_convertation_model_convertCurrency_sourceToTarget_throws() {
        let exchangeRate = ExchangeRate(source: .init(code: "C1"), target: .init(code: "C2"), rateValue: -0.01)
        let description = ConvertationDescription(exchangeRate: exchangeRate, originalAmount: 1.0, interest: 0.0)

        let sut: ConvertationModel = ConvertationModelImpl()

        XCTAssertThrowsError(try sut.execute(convertation: description))
    }
}
