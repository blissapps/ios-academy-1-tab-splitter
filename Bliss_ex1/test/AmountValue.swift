//
//  AmountValue.swift
//  Bliss_ex1
//
//  Created by Filipe Santo on 20/10/2021.
//

import Foundation

public struct AmountValue: Equatable, Codable {
    public var value: Decimal
    public var currencyCode: String
    
    public init(value: Decimal, currencyCode: String) {
        self.value = value
        self.currencyCode = currencyCode
    }

}
