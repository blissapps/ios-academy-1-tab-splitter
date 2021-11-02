//
//  BillSpliterEngine.swift
//  BillSplitterApp
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
                
            } else {
                
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
            
        }
        
        set {
            
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
