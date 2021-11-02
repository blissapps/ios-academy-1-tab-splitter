//
//  AmountValue+Operators.swift
//  AmountValue
//
//  Created by Filipe Santo on 20/10/2021.
//

import Foundation
import UIKit

infix operator >>> : AdditionPrecedence

enum AmountValueError: Error, Hashable {
    case initializeError_noCurrencyCodeInRates
    case convertError_unknownSourceCurrency(currencyCode: String)
    case convertError_unknownTargetCurrency(currencyCode: String)
}

extension AmountValue {
    static var posixLocale =  Locale(identifier: "en_US_POSIX")

    static func posixFormatter(currencyCode: String) -> NumberFormatter {
        let f = NumberFormatter()
        f.currencyCode = currencyCode
        f.numberStyle = .currency
        f.locale = AmountValue.posixLocale
        return f
    }

    static func decimalPlacesForCurrency(currencyCode: String) -> Int {
        var r = posixFormatter(currencyCode: currencyCode).string(from: 0)!
        r = r.replaceCharactersFromSet(characterSet: CharacterSet.decimalDigits.union(CharacterSet(charactersIn: ".")).inverted)
        guard r.contains(".") else {
            return 0
        }
        return r.replacingOccurrences(of: "0.", with: "").count
    }

    public static var currencies: [String] {
        exchangeRates.keys.map{$0}
    }
    
    public static func initialize (currencyCode: String, rates: [String: Decimal]) throws {
        guard rates[currencyCode] != nil else {
            throw AmountValueError.initializeError_noCurrencyCodeInRates
        }

        exchangeRates[currencyCode] = rates

        for keyCurrency in rates.keys {
            
            var ratesForKeyCurrency: [String: Decimal] = [:]
            
            for item in rates {
                guard let keyRate = rates[keyCurrency],
                      let secondKeyRates = rates[item.key] else { continue }
                ratesForKeyCurrency[item.key] = secondKeyRates / keyRate
            }
            exchangeRates[keyCurrency] = ratesForKeyCurrency
        }
    }
    
    static var exchangeRates: [String: [String: Decimal]] = [:]

    private static func convert(value: Decimal, fromCurrency: String, toCurrency: String) throws -> Decimal {
        guard let sourceCurrencyRates = exchangeRates[fromCurrency] else {
            throw AmountValueError.convertError_unknownSourceCurrency(currencyCode: fromCurrency)
        }
        guard let targetCurrencyRate = sourceCurrencyRates[toCurrency] else {
            throw AmountValueError.convertError_unknownTargetCurrency(currencyCode: toCurrency)
        }
        return value * targetCurrencyRate
    }

    public static func >>>(lhs: AmountValue, rhs: String) throws -> AmountValue {
        let baseAmount = lhs.value
        let baseCurrency = lhs.currencyCode
        let convertedAmount = try convert(value: baseAmount, fromCurrency: baseCurrency, toCurrency: rhs)
        return AmountValue(value: convertedAmount,
                           currencyCode: rhs)
    }

    public static func +(lhs: AmountValue, rhs: AmountValue) throws -> AmountValue {
        let baseAmount1 = lhs.value
        let baseAmount2 = try (rhs >>> lhs.currencyCode).value
        return AmountValue(
            value: baseAmount1 + baseAmount2,
            currencyCode: lhs.currencyCode
        )
    }

    public static func -(lhs: AmountValue, rhs: AmountValue) throws -> AmountValue {
        let baseAmount1 = lhs.value
        let baseAmount2 = try (rhs >>> lhs.currencyCode).value
        return AmountValue(
            value: baseAmount1 - baseAmount2,
            currencyCode: lhs.currencyCode
        )
    }

    public static func /(lhs: AmountValue, rhs: Int) throws -> (AmountValue, AmountValue) {
        var value = lhs.value / Decimal(rhs)
        var result = value
        NSDecimalRound(&result, &value, AmountValue.decimalPlacesForCurrency(currencyCode: lhs.currencyCode), .bankers)
        let valueWithoutRemainder = result * Decimal(rhs)
        let remainder = lhs.value - valueWithoutRemainder
        let resultAmount = AmountValue(value: result, currencyCode: lhs.currencyCode)
        let remainderAmount = AmountValue(value: remainder, currencyCode: lhs.currencyCode)
        return (resultAmount, remainderAmount)
    }

    public static func /(lhs: AmountValue, rhs: Decimal) throws -> AmountValue {
        try lhs * (1 / rhs)
    }

    public static func *(lhs: AmountValue, rhs: Decimal) throws -> AmountValue {
        AmountValue(
            value: lhs.value * rhs,
            currencyCode: lhs.currencyCode
        )
    }

    public var symmetric: AmountValue {
        AmountValue(value: -value, currencyCode: currencyCode)
    }
}

extension AmountValue: Comparable {
    public static func < (lhs: AmountValue, rhs: AmountValue) -> Bool {
        do {
            let rhsInLhsCurrencyCode = try rhs >>> lhs.currencyCode
            return lhs.value < rhsInLhsCurrencyCode.value
        } catch {
            fatalError("\(error)")
        }
    }
}

extension AmountValue: CustomDebugStringConvertible {
    var formatter: NumberFormatter {
        let f = NumberFormatter()
        f.numberStyle = .currency
        f.currencyCode = currencyCode
        return f
    }

    public var debugDescription: String {
        formatter.string(for: value) ?? "N.A."
    }
}

extension String {
    func replaceCharactersFromSet(characterSet: CharacterSet, replacementString: String = "") -> String {
        return self.components(separatedBy: characterSet).joined(separator: replacementString)
    }
}
