//
//  AmountValueTests.swift
//  AmountValueTests
//
//  Created by Filipe Santo on 28/10/2021.
//

import XCTest
//
import TestUtils
//
@testable import AmountValue


class AmountValueTests: XCTestCase {


    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAmountValue_decimalPlacesForCurrency() {
        XCTAssertEqual(AmountValue.decimalPlacesForCurrency(currencyCode: "EUR"), 2)
        XCTAssertEqual(AmountValue.decimalPlacesForCurrency(currencyCode: "JPY"), 0)
        XCTAssertEqual(AmountValue.decimalPlacesForCurrency(currencyCode: "CLF"), 4)
        XCTAssertEqual(AmountValue.decimalPlacesForCurrency(currencyCode: "BTC"), 2)
        XCTAssertEqual(AmountValue.decimalPlacesForCurrency(currencyCode: "XXX"), 2)
    }

    func testAmountValue_initialize_fatalError_noCurrencyCodeInExchangeRates() throws {
        XCTAssertThrowsError(try AmountValue.initialize(currencyCode: "EUR", rates: ["USD": oneDotOneDecimal]))
    }

    func testAmountValue_initialize() throws {
        XCTAssertNoThrow(try AmountValue.initialize(currencyCode: "EUR", rates: ["USD": oneDotOneDecimal, "EUR": oneDecimal]))
        let eurToUsd = AmountValue.exchangeRates["EUR"]?["USD"]
        let usdToEur = AmountValue.exchangeRates["USD"]?["EUR"]
        print(AmountValue.exchangeRates)
        XCTAssertNotNil(eurToUsd)
        XCTAssertNotNil(usdToEur)
        XCTAssertEqual(eurToUsd, oneDotOneDecimal)
        XCTAssertEqual(usdToEur, oneDecimal / oneDotOneDecimal)
    }

    func testAmountValue_currencies() throws {
        XCTAssertNoThrow(try AmountValue.initialize(currencyCode: "EUR", rates: ["USD": oneDotOneDecimal, "EUR": oneDecimal]))
        XCTAssertEqual(Set(AmountValue.currencies), Set(arrayLiteral: "USD", "EUR"))
    }

    func testAmountValue_operatorConvert_happyPath() throws {
        XCTAssertNoThrow(try AmountValue.initialize(currencyCode: "EUR", rates: ["USD": oneDotOneDecimal, "EUR": oneDecimal]))
        let oneEurInUsd = try? AmountValue(value: oneDecimal, currencyCode: "EUR") >>> "USD"
        let precalculatedOneEurInUsd = AmountValue(value: oneDecimal * oneDotOneDecimal, currencyCode: "USD")
        XCTAssertEqual(oneEurInUsd, precalculatedOneEurInUsd)
    }

    func testAmountValue_operatorConvert_notSoHappyPath() throws {
        XCTAssertNoThrow(try AmountValue.initialize(currencyCode: "EUR", rates: ["USD": oneDotOneDecimal, "EUR": oneDecimal]))
        XCTAssertThrowsError(try AmountValue(value: oneDecimal, currencyCode: "AED") >>> "EUR", "Call did not throw", { error in
            XCTAssertNotNil(error as? AmountValueError)
            XCTAssertEqual(error as? AmountValueError, AmountValueError.convertError_unknownSourceCurrency(currencyCode: "AED"))
        })
        XCTAssertThrowsError(try AmountValue(value: oneDecimal, currencyCode: "EUR") >>> "AED", "Call did not throw", { error in
            XCTAssertNotNil(error as? AmountValueError)
            XCTAssertEqual(error as? AmountValueError, AmountValueError.convertError_unknownTargetCurrency(currencyCode: "AED"))
        })
    }

    func testAmountValue_operatorAddition_happyPath() throws {
        XCTAssertNoThrow(try AmountValue.initialize(currencyCode: "EUR", rates: ["USD": oneDotOneDecimal, "EUR": oneDecimal]))
        let a1 = AmountValue(value: oneDecimal, currencyCode: "EUR")
        let a2 = AmountValue(value: oneDecimal, currencyCode: "EUR")
        let a1PlusA2 = AmountValue(value: oneDecimal + oneDecimal, currencyCode: "EUR")
        XCTAssertEqual(try a1 + a2, a1PlusA2)
    }

    func testAmountValue_operatorSubtraction_happyPath() throws {
        XCTAssertNoThrow(try AmountValue.initialize(currencyCode: "EUR", rates: ["USD": oneDotOneDecimal, "EUR": oneDecimal]))
        let a1 = AmountValue(value: oneDecimal, currencyCode: "EUR")
        let a2 = AmountValue(value: oneDecimal, currencyCode: "EUR")
        let a1MinusA2 = AmountValue(value: oneDecimal - oneDecimal, currencyCode: "EUR")
        XCTAssertEqual(try a1 - a2, a1MinusA2)
    }

    func testAmountValue_operatorDivisionInteger_happyPathCLF() throws {
        XCTAssertNoThrow(try AmountValue.initialize(currencyCode: "CLF", rates: ["CLF": oneDecimal]))
        let a1 = AmountValue(value: oneDecimal, currencyCode: "CLF")
        let i1 = 3
        let a1OverI1Result = AmountValue(value: zeroDot3333Decimal, currencyCode: "CLF")
        let a1OverI1Remainder = AmountValue(value: zeroDot0001Decimal, currencyCode: "CLF")
        let result = try! a1 / i1
        let (resultValue, remainderValue) = result
        XCTAssertEqual(resultValue, a1OverI1Result)
        XCTAssertEqual(remainderValue, a1OverI1Remainder)
    }

    func testAmountValue_operatorDivisionInteger_happyPath() throws {
        XCTAssertNoThrow(try AmountValue.initialize(currencyCode: "EUR", rates: ["USD": oneDotOneDecimal, "EUR": oneDecimal]))
        let a1 = AmountValue(value: oneDecimal, currencyCode: "EUR")
        let i1 = 3
        let a1OverI1Result = AmountValue(value: zeroDot33Decimal, currencyCode: "EUR")
        let a1OverI1Remainder = AmountValue(value: zeroDot01Decimal, currencyCode: "EUR")
        let result = try! a1 / i1
        let (resultValue, remainderValue) = result
        XCTAssertEqual(resultValue, a1OverI1Result)
        XCTAssertEqual(remainderValue, a1OverI1Remainder)
    }

    func testAmountValue_operatorDivisionDecimal_happyPath() throws {
        XCTAssertNoThrow(try AmountValue.initialize(currencyCode: "EUR", rates: ["USD": oneDotOneDecimal, "EUR": oneDecimal]))
        let a1 = AmountValue(value: oneDecimal, currencyCode: "EUR")
        let i1 = Decimal(string: "3.0")!
        let a1OverI1Result = AmountValue(value: oneDecimal / threeDecimal, currencyCode: "EUR")
        let result = try a1 / i1
        XCTAssertEqual(result, a1OverI1Result)
    }

    func testAmountValue_operatorMultiplicationDecimal_happyPath() throws {
        XCTAssertNoThrow(try AmountValue.initialize(currencyCode: "EUR", rates: ["USD": oneDotOneDecimal, "EUR": oneDecimal]))
        let a1 = AmountValue(value: oneDecimal, currencyCode: "EUR")
        let i1 = Decimal(string: "3.0")!
        let a1OverI1Result = AmountValue(value: oneDot5Decimal * twoDecimal, currencyCode: "EUR")
        let result = try a1 * i1
        XCTAssertEqual(result, a1OverI1Result)
    }

}
