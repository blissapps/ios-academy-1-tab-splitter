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
        addUser(user)
        addChangedUser(user)
        addValue()
        uptadeRest()
        delegate?.reloadData()
        selectedUser = nil
        selectedOption = nil
    }
    
    func addUser(_ user:BillItem) {
        guard let index = users.firstIndex(where: { $0.id == user.id }) else {
            users.append(user)
            return
        }
        users[index] = user
    }
    
    func addChangedUser(_ user: BillItem) {
        if user.changedUser == false {
            if let index = changedUsers.firstIndex(where: { $0.id == user.id }) {
                changedUsers.remove(at: index)
            }
        } else {
            guard let index = changedUsers.firstIndex(where: { $0.id == user.id }) else {
                changedUsers.append(user)
                return
            }
            changedUsers[index] = user
        }
    }
    
    func addValue() {
        /*
        var changedValue: Double = 0
        var valueAmount: Double = 0

        changedUsers.forEach { changedValue += ($0.value ?? 0) }
        
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
        }*/
    }
    
    func uptadeRest() {
        var rest: Double = 0
        users.forEach{ rest += ($0.value ?? 0)}
        restAmount = billAmount -  rest
        delegate?.updateRest(with: "\(String(restAmount))€")
    }
    
    func billAmountDidChange(_ value: Double) {
        billAmount = value
    }
}
