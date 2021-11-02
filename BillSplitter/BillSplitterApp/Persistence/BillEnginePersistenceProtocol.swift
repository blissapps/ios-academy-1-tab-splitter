//
//  BillEnginePersistenceProtocol.swift
//  BillSplitterApp
//
//  Created by Tiago Janela on 11/2/21.
//

import Foundation
//
import AmountValue
import BillSplitter

public protocol BillEnginePersistenceProtocol {
    func savedUsers() -> [BillItem]
    func savedBillAmount() -> AmountValue

    func updateUsers(users: [BillItem])
    func updateBillAmount(billAmount: AmountValue)
}
