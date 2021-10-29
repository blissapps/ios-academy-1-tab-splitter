//
//  BillItem.swift
//  Bliss_ex1
//
//  Created by Filipe Santo on 30/09/2021.
//

import Foundation
import UIKit


public struct BillItem: Equatable, Codable {
    let id = UUID().uuidString
    
    public var name: String?
    public var amount: AmountValue?
    public var changedUser: Bool?
    
    public init (name: String, amount: AmountValue, changedUser: Bool) {
        self.name = name
        self.amount  = amount
        self.changedUser = changedUser
    }
}
