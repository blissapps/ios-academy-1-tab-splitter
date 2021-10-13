//
//  DecimalParser.swift
//  Bliss_ex1
//
//  Created by Tiago Janela on 10/6/21.
//

import Foundation

public enum DecimalParseResult {
    case failure
    case success(Decimal)
}

public struct DecimalParser {
    private static var formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        return formatter
    }()

    private static var currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        return formatter
    }()

    static let invalidCharacters = CharacterSet.decimalDigits.union(CharacterSet(arrayLiteral: ".",",")).inverted

    public static func parseDecimalString(_ value: String) -> DecimalParseResult {
        let sanitizedValue = value.trimmingCharacters(in: invalidCharacters)
        guard let result = formatter.number(from: sanitizedValue)?.decimalValue else {
            return .failure
        }
        return .success(result)
    }

    public static func formatDecimal(_ value: Decimal) -> String {
        guard let result = formatter.string(from: value as NSDecimalNumber) else {
            return ""
        }
        return result
    }

    public static func formatAsCurrencyDecimal(_ value: Decimal) -> String {
        guard let result = currencyFormatter.string(from: value as NSDecimalNumber) else {
            return ""
        }
        return result
    }
}

public extension Decimal {
    var displayFormat: String {
        DecimalParser.formatDecimal(self)
    }

    var displayAsCurrencyFormat: String {
        DecimalParser.formatAsCurrencyDecimal(self)
    }
}
