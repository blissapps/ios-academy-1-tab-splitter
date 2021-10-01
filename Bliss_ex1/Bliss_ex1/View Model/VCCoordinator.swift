//
//  VCCoordinator.swift
//  Bliss_ex1
//
//  Created by Filipe Santo on 30/09/2021.
//

import Foundation
import UIKit

final class VCCoordinator: CoordinatorProtocol {
    weak var delegate: CoordinatorDelegate?
    
    var billAmount: Double = 0
    var restAmount: Double = 0
    
    var selectedUser: BillItem?
    var users: [BillItem] = []
    
    private var changedUsers: [BillItem] = []
    
    var selectedOption: OperationOption?
    
    func selectUser(at index: Int) {
        selectedUser = users[index]
        selectedOption = .save
        delegate?.next()
    }
    
    func reset() {
        users = []
        restAmount = 0
        billAmount = 0
        selectedUser = nil
        selectedOption = nil
        
        delegate?.updateRest(with: "\(restAmount)€")
        delegate?.updateTotal(with: "\(billAmount)€")
        delegate?.reloadData()
    }
    
    func setBill(bill: Double) {
        self.billAmount = bill
    }
    
    func add() {
        selectedOption = .add
        delegate?.next()
    }
     
    func saveUser(_ user: BillItem) {
        if selectedOption == .add {
            users.append(user)
        } else {
            if let index = users.firstIndex(where: { $0 == user }) {
                users[index] = user
                
                if let index = changedUsers.firstIndex(where: { $0 == user }) {
                    changedUsers[index] = user
                } else {
                    changedUsers.append(user)
                }
            }
        }
        
        print("Todo - calculate amounts and users")
        
        
        delegate?.reloadData()
        
        selectedUser = nil
        selectedOption = nil
    }
    
    func billAmountDidChange(_ value: Double) {
        billAmount = value
    }
}
