//
//  VCCoordinator.swift
//  Bliss_ex1
//
//  Created by Filipe Santo on 30/09/2021.
//

import Foundation
import UIKit

final class VCCoordinator: CoordinatorProtocol {
    var billEngine = BillSpliterEngine()
    
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
        billEngine.reset()
        selectedUser = nil
        selectedOption = nil
        
        delegate?.updateRest(with: "\(billEngine.restAmount)€")
        delegate?.updateTotal(with: "\(billEngine.billAmount)€")
        delegate?.reloadData()
    }
    
    func setBill(bill: Decimal) {
        billEngine.setBill(bill)
    }
    
    func add() {
        selectedOption = .add
        delegate?.next()
    }
    
    func back() {
        selectedUser = nil
        selectedOption = nil
        delegate?.next()
    }
     
    func saveUser(_ user: BillItem) {
        billEngine.saveUser(user)
        users = billEngine.users
        delegate?.reloadData()
        selectedUser = nil
        selectedOption = nil
    }
    
    func uptadeRest() {
        billEngine.uptadeRest()
        delegate?.updateRest(with: "\((billEngine.restAmount).description)€")
    }
    
    func billAmountDidChange(_ value: Decimal) {
        billEngine.billAmountDidChange(value)
    }
}
