//
//  VCCoordinator.swift
//  Bliss_ex1
//
//  Created by Filipe Santo on 30/09/2021.
//

import Foundation
import UIKit

final class VCCoordinator: CoordinatorProtocol {
    weak var billEngine: BillEngine?
    
    var delegate: CoordinatorDelegate?
    var selectedUser: BillItem?
    var selectedOption: OperationOption?
    var users: [BillItem] = []
    
    
    func selectUser(at index: Int) {
        selectedUser = users[index]
        selectedOption = .save
        delegate?.next()
    }
    
    func reset() {
        billEngine?.reset()
        
        delegate?.updateRest(with: "\(billEngine?.restAmount ?? 0)€")
        delegate?.updateTotal(with: "\(billEngine?.billAmount ?? 0)€")
       delegate?.reloadData()
    }
    
    func setBill(bill: Decimal) {
        billEngine?.setBill(bill)
    }
    
    func add() {
        billEngine?.add()
        delegate?.next()
    }
    
    func back() {
        billEngine?.back()
        delegate?.next()
    }
     
    func saveUser(_ user: BillItem) {
        billEngine?.saveUser(user)
        delegate?.reloadData()
    }
    
    func uptadeRest() {
        billEngine?.uptadeRest()
        delegate?.updateRest(with: "\((billEngine?.restAmount ?? 0).description)€")
    }
    
    func billAmountDidChange(_ value: Decimal) {
        billEngine?.billAmountDidChange(value)
    }
}
