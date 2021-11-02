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
    private var _users: [BillItem] = []
    public var users: [BillItem] {
        get { _users }
        set {
            _users = newValue
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
        _users.filter({ $0.changedUser == true })
    }

    //MARK: - Public methods
    public func reset() {
        users = []
        billAmount = BillSplitterEngine.initialAmount
    }
     
    /*public func saveUser(_ user: BillItem) {
        addUser(user)
        recalculate()
    }
    
    public func addUser(_ user:BillItem) {
        if !users.contains(user) {
            users.append(user)
            return
        }
        users.replace(id: user.id, user: user)
    }*/

    //MARK: - Private methods
    private func recalculate() {
        let zeroAmount = AmountValue(value: 0, currencyCode: billAmount.currencyCode)

        do {
            var valueAmount = zeroAmount
            var divisionRemainderAmount = zeroAmount

            var changedValue = try changedUsers
                .compactMap { $0.amount }
                .reduce(zeroAmount, { (previous, current) -> AmountValue in try previous + current })
            let numberOfUnchangedUser = _users.count - changedUsers.count

            if (try billAmount - changedValue) < zeroAmount {
                valueAmount = zeroAmount
            } else {
                (valueAmount, divisionRemainderAmount) = try (billAmount - changedValue) / numberOfUnchangedUser
            }

            for (index, user) in _users.enumerated() {
                if !changedUsers.contains(user) {
                    let currencyCode = users[index].amount?.currencyCode ?? billAmount.currencyCode
                    _users[index].amount = try valueAmount >>> currencyCode
                }
            }

            let allocatedAmount = try _users
                .compactMap { $0.amount }
                .reduce(zeroAmount, { try $0 + $1 })

            restAmount = try billAmount - allocatedAmount
        } catch {
            #if DEBUG
            fatalError("\(error)")
            #else
            //qlq outra coisa que nao crasha
            #endif
        }

        //update remainder
    }
}
