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
    
    func back() {
        selectedUser = nil
        selectedOption = nil
    }
     
    func saveUser(_ user: BillItem) {
        var valueAmount: Double = 0

        if selectedOption == .add {
            users.append(user)
        } else {
            if let index = users.firstIndex(where: { $0.id == user.id }) {
                users[index] = user
                
                if let index = changedUsers.firstIndex(where: { $0.id == user.id }) {
                    changedUsers[index] = user
                } else {
                    changedUsers.append(user)
                }
            }
        }
 
        var changedValue: Double = 0
        
        changedUsers.forEach { changedValue += ($0.value ?? 0) }
        print("changed value = \(changedValue)")
        
        let numberOfUnchangedUser = Double(users.count - changedUsers.count)
        
        if numberOfUnchangedUser != 0.0 && !changedUsers.isEmpty {
            valueAmount =
                (billAmount - changedValue) / numberOfUnchangedUser
            
            let changedIds = changedUsers.map { $0.id }

            for (index, user) in users.enumerated() {
                if !changedIds.contains(user.id) {
                    users[index].value = valueAmount
                }
            }
        }
        
        delegate?.reloadData()
        
        selectedUser = nil
        selectedOption = nil
    }
    
    func billAmountDidChange(_ value: Double) {
        billAmount = value
    }
}
