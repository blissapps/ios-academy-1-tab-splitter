//
//  BillSpliterEngine.swift
//  Bliss_ex1
//
//  Created by João Barros on 04/10/2021.
//

import Foundation
//
import AmountValue

public class BillSplitterEngine {
    //MARK: - Private vars
    static let initialAmount = AmountValue(value: 0, currencyCode: "EUR")
    public var billAmountDidChange: ((AmountValue) -> Void)?
    public var billAmount: AmountValue = BillSplitterEngine.initialAmount {
        didSet {
            billAmountDidChange?(billAmount)
        }
        /*get {
            if FeatureFlags.shared.isUserDefaultsOn {
                guard let bill = UserDefaults.standard.data(forKey: "billAmount") else {
                    return AmountValue(value: 0, currencyCode: "EUR")
                }
                let decoder = JSONDecoder()

                return (try? decoder.decode(AmountValue.self, from: bill)) ?? AmountValue(value: 0, currencyCode: "EUR")
            } else {
                let fileManager = FileManager.default
                
                let foulder = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)
                guard let fileURL = foulder.first?.appendingPathComponent("billAmount" + ".cache") else {        return AmountValue(value: 0, currencyCode: "EUR")
                }
                
                guard let data = try? Data(contentsOf: fileURL) else {
                    return AmountValue(value: 0, currencyCode: "EUR")
                }
                let decoder = JSONDecoder()

                return (try? decoder.decode(AmountValue.self, from: data)) ?? AmountValue(value: 0, currencyCode: "EUR")
            }
        }

        set {
            if FeatureFlags.shared.isUserDefaultsOn {
                guard let data = try? JSONEncoder().encode(newValue) else { return }
                UserDefaults.standard.set(data, forKey: "billAmount")
                recalculate()
            } else {
                let fileManager = FileManager.default
                
                let foulder = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)
               
                guard  let fileURL = foulder.first?.appendingPathComponent("billAmount" + ".cache"),
                       let data = try? JSONEncoder().encode(newValue) else {return}
                try? data.write(to: fileURL)
            }
        }*/
    }
    
    public var restAmount: AmountValue = BillSplitterEngine.initialAmount

    public var usersDidChange: (([BillItem]) -> Void)?
    public var users: [BillItem] = [] {
        didSet {
            recalculate()
            usersDidChange?(users)
        }
        /*get {
            guard let user = UserDefaults.standard.data(forKey: "userArray") else {
                return []
            }
            let decoder = JSONDecoder()
            
            return (try? decoder.decode([BillItem].self, from: user)) ?? []
        }
        
        set {
            guard let data = try? JSONEncoder().encode(newValue) else { return }
            UserDefaults.standard.set(data, forKey: "userArray")
        }*/
    }
    
    public init() {}

    //MARK: - Private computed vars
    private var changedUsers: [BillItem] {
        users.filter({ $0.changedUser == true })
    }

    //MARK: - Public methods
    public func reset() {
        users = []
        billAmount = BillSplitterEngine.initialAmount
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
        let zeroAmount = AmountValue(value: 0, currencyCode: billAmount.currencyCode)
        var rest: AmountValue = zeroAmount
        users.forEach{ rest = (try? rest + ($0.amount ?? zeroAmount)) ?? zeroAmount }
        restAmount = (try? billAmount - rest) ?? zeroAmount
    }
}
