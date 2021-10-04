//
//  BillSpliterEngine.swift
//  Bliss_ex1
//
//  Created by João Barros on 04/10/2021.
//

import Foundation

class BillEngine {
    
    var billAmount: Decimal = 0
    var restAmount: Decimal = 0

    var selectedUser: BillItem?
    var users: [BillItem] = []
    
    private var changedUsers: [BillItem] = []
    
    var selectedOption: OperationOption?
    
    func reset() {
        users = []
        restAmount = 0
        billAmount = 0
        selectedUser = nil
        selectedOption = nil
    }
    
    func setBill(_ bill: Decimal) {
        self.billAmount = bill
    }
    
    func add() {
        selectedOption = .add
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
        
        var changedValue: Decimal = 0
        var valueAmount: Decimal = 0

        changedUsers.forEach { changedValue += ($0.value ?? 0) }

        let numberOfUnchangedUser = Decimal(users.count - changedUsers.count)
        
        if (billAmount - changedValue) < 0 {
            valueAmount = 0
        } else {
            if numberOfUnchangedUser == 0 {
                valueAmount = 0
            } else {
                valueAmount = (billAmount - changedValue) / numberOfUnchangedUser
            }
        }
        changedUsers.forEach({print($0.value)})
        for (index, user) in users.enumerated() {
            if !changedUsers.contains(user) {
                users[index].value = valueAmount
            }
        }
    }
    
    func uptadeRest() {
        var rest: Decimal = 0
        users.forEach{ rest += ($0.value ?? 0)}
        restAmount = billAmount -  rest
    }
    
    func billAmountDidChange(_ value: Decimal) {
        billAmount = value
    }

}
