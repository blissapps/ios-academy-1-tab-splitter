//
//  BillSpliterEngine.swift
//  Bliss_ex1
//
//  Created by João Barros on 04/10/2021.
//

import Foundation

//#import <Bliss_ex1/Helpers/Extensions/BillItem+ArrayExtension.swift>

public class BillSpliterEngine {
    //MARK: - Private vars
    public var billAmount: AmountValue {
        get {
            guard let bill = UserDefaults.standard.data(forKey: "billAmount") else {
                return AmountValue(value: 0, currencyCode: "EUR")
            }
            let decoder = JSONDecoder()

            return (try? decoder.decode(AmountValue.self, from: bill)) ?? AmountValue(value: 0, currencyCode: "EUR")
        }

        set {
            guard let data = try? JSONEncoder().encode(newValue) else { return }
            UserDefaults.standard.set(data, forKey: "billAmount")
            recalculate()
        }
    }
    
    public var restAmount: Decimal = 0
    
    public var users: [BillItem] {
        get {
            guard let user = UserDefaults.standard.data(forKey: "userArray") else {
                return []
            }
            let decoder = JSONDecoder()
            
            return (try? decoder.decode([BillItem].self, from: user)) ?? []
        }
        
        set {
            guard let data = try? JSONEncoder().encode(newValue) else { return }
            UserDefaults.standard.set(data, forKey: "userArray")
        }
    }
    
    public init() {}

    //MARK: - Private computed vars
    private var changedUsers: [BillItem] {
        users.filter({ $0.changedUser == true })
    }

    //MARK: - Public methods
    public func reset() {
        users = []
        billAmount.value = 0
    }
     
    public func saveUser(_ user: BillItem) {
        addUser(user)
        recalculate()
    }
    
    public func addUser(_ user:BillItem) {
        if !users.contains(user) {
            users.append(user)
            return
        }
        users.replace(id: user.id, user: user)
    }

    //MARK: - Private methods
    private func recalculate() {
        
        var changedValue: Decimal = 0
        var valueAmount: Decimal = 0

        changedUsers.forEach { changedValue += ($0.amount?.value ?? 0) }

        let numberOfUnchangedUser = Decimal(users.count - changedUsers.count)
        
        if (billAmount.value - changedValue) < 0 {
            valueAmount = 0
        } else {
            valueAmount = (billAmount.value - changedValue) / numberOfUnchangedUser
        }
        
        for (index, user) in users.enumerated() {
            if changedUsers.contains(user) {
                users[index].amount?.value = valueAmount
            }
        }

        //update remainder
        var rest: Decimal = 0
        users.forEach{ rest += ($0.amount?.value ?? 0)}
        restAmount = billAmount.value -  rest
    }
}