//
//  BillItem.swift
//  Bliss_ex1
//
//  Created by Filipe Santo on 30/09/2021.
//
// PR TEST 3

import Foundation
import UIKit

public struct BillItem: Equatable {
    let id = UUID().uuidString
    
    public var name: String?
    public var amount: AmountValue?
    public var changedUser: Bool?
}
