//
//  BillItem.swift
//  Bliss_ex1
//
//  Created by Filipe Santo on 30/09/2021.
//

import Foundation
import UIKit

struct BillItem: Equatable {
    let id = UUID().uuidString
    
    var name: String?
    var value: Decimal?
    var changedUser: Bool?
}
