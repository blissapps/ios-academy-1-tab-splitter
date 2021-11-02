//
//  AmountValueTestUtils.swift
//  TestUtils
//
//  Created by Tiago Janela on 11/2/21.
//

import Foundation
import AmountValue

public let posixLocale = Locale(identifier: "en_US_POSIX")

public let zeroDecimal = Decimal(string: "0", locale: posixLocale)!
public let zeroDot33Decimal = Decimal(string: "0.33", locale: posixLocale)!
public let zeroDot01Decimal = Decimal(string: "0.01", locale: posixLocale)!
public let zeroDot3333Decimal = Decimal(string: "0.3333", locale: posixLocale)!
public let zeroDot333333Decimal = Decimal(string: "0.333333", locale: posixLocale)!
public let zeroDot0001Decimal = Decimal(string: "0.0001", locale: posixLocale)!
public let oneDotOneDecimal = Decimal(string: "1.1", locale: posixLocale)!
public let oneDecimal = Decimal(string: "1", locale: posixLocale)!
public let oneDot5Decimal = Decimal(string: "1.5", locale: posixLocale)!
public let twoDecimal = Decimal(string: "2", locale: posixLocale)!
public let threeDecimal = Decimal(string: "3", locale: posixLocale)!

public let zeroEur = AmountValue(value: zeroDecimal, currencyCode: "EUR")
public let oneEur = AmountValue(value: oneDecimal, currencyCode: "EUR")
public let threeEur = AmountValue(value: oneDecimal * 3, currencyCode: "EUR")
