//
//  Double+Extensions.swift
//  Bliss_ex1
//
//  Created by Filipe Santo on 01/10/2021.
//

import Foundation

extension Double {
    var displayText: String {
        return String(format: "%f", self)
    }
    
    func roundToPlaces(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension Optional where Wrapped == Double {
    var displayText: String {
        (self ?? 0).displayText
    }
}
