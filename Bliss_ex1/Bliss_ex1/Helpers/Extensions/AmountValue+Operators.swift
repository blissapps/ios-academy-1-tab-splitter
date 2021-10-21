//
//  AmountValue+Operators.swift
//  Bliss_ex1
//
//  Created by Filipe Santo on 20/10/2021.
//

import Foundation
import UIKit

infix operator >>> : AdditionPrecedence

extension AmountValue {
    
    public static func initialize (currencyCode: String, rates: [String: Decimal]){
        exchangeRates[currencyCode] = rates
        for keyCurrency in rates.keys{
            var 
        }
    }
    
    //     AmountValue.initialize(currencyCode: latest.base, rates: latest.rates)

    
    private static var exchangeRates: [String: [String: Decimal]] = [:]

    private static func convert(value: Decimal, fromCurrency: String, toCurrency: String) -> Decimal {
        value * (exchangeRates[fromCurrency]?[toCurrency] ?? 0)
    }

    static func >>>(lhs: AmountValue, rhs: String) -> AmountValue {
        let baseAmount = lhs.value
        let baseCurrency = lhs.currencyCode
        let convertedAmount = convert(value: baseAmount, fromCurrency: baseCurrency, toCurrency: rhs)
        return AmountValue(value: convertedAmount,
                           currencyCode: rhs)
    }

    static func +(lhs: AmountValue, rhs: AmountValue) -> AmountValue {
        let baseAmount1 = lhs.value
        let baseAmount2 = (rhs >>> lhs.currencyCode).value
        return AmountValue(
            value: baseAmount1 + baseAmount2,
            currencyCode: lhs.currencyCode
        )
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
