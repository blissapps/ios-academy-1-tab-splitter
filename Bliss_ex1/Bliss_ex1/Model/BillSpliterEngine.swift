//
//  BillSpliterEngine.swift
//  Bliss_ex1
//
//  Created by João Barros on 04/10/2021.
//

import Foundation

public class BillSpliterEngine {
    
    let apiClient = ApiClient()
    
    var latest: LatestDto?
   
    //MARK: - Private vars
    public var amount: AmountValue = AmountValue(amount: billAmount, currencyCode: EUR) {
        amount?.amount =
    }
    
    private var billAmount: Decimal = 0 {
        didSet {
            recalculate()
        }
    }
    public var restAmount: Decimal = 0
    
    public var users: [BillItem] = []
    
    //MARK: - Private computed vars
    private var changedUsers: [BillItem] {
        users.filter({ $0.changedUser == true })
    }

    //MARK: - Public methods
    init () {
        apiClient.getLatest { latest in
            self.latest = latest
        }
    }

    func reset() {
        users = []
        billAmount = 0
    }
     
    func saveUser(_ user: BillItem) {
        addUser(user)
        recalculate()
    }
    
    func addUser(_ user:BillItem) {
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

        changedUsers.forEach { changedValue += ($0.value?.amount ?? 0) }

        let numberOfUnchangedUser = Decimal(users.count - changedUsers.count)
        
        if (billAmount - changedValue) < 0 {
            valueAmount = 0
        } else {
            valueAmount = (billAmount - changedValue) / numberOfUnchangedUser
        }
        
        for (index, user) in users.enumerated() {
            if !changedUsers.contains(user) {
                users[index].value?.amount = valueAmount
            }
        }

        //update remainder
        var rest: Decimal = 0
        users.forEach{ rest += ($0.value?.amount ?? 0)}
        restAmount = billAmount -  rest
    }

    
    //MARK: - CurrencyChanged

    func currencyChanged(newCurrency: String) {
        //=(valor atual/valor de coversão para a moeda do atual)*(valor conversao da nova moeda)
        guard let prevValue = latest?.rates[amount.currencyCode],
              let newValue = latest?.rates[newCurrency] else {
            return
        }
        billAmount = (billAmount / prevValue)/newValue
    }
}

