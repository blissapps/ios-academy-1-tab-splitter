//
//  Double+Extensions.swift
//  BillSplitterApp
//
//  Created by Filipe Santo on 01/10/2021.
//

import Foundation
import AmountValue
import BillSplitter

// Pull request test

extension Decimal {
    var displayText: String {
        return String(format: "%@", self.description)
    }
    
    mutating func roundToPlaces(places:Int) -> Decimal {
        var result = self
        NSDecimalRound(&self, &result, places, .bankers)
        return self
    }
}

extension Optional where Wrapped == Decimal {
    var displayText: String {
        (self ?? 0).displayText
    }
}
