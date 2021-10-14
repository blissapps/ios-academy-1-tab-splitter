//
//  BillItem.swift
//  Bliss_ex1
//
//  Created by Filipe Santo on 30/09/2021.
//

import Foundation
import UIKit

public struct BillItem: Equatable {
    let id = UUID().uuidString
    
    public var name: String?
    public var value: AmountValue?
    public var changedUser: Bool?
}

public struct AmountValue: Equatable {
    var amount: Decimal
    var currencyCode: String
}
