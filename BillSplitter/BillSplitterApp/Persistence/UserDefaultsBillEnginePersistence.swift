//
//  UserDefaultsBillEnginePersistence.swift
//  BillSplitterApp
//
//  Created by Tiago Janela on 11/2/21.
//

import Foundation
//
import AmountValue
import BillSplitter

class UserDefaultsBillEnginePersistence: BillEnginePersistenceProtocol {
    func savedUsers() -> [BillItem] {
        guard let user = UserDefaults.standard.data(forKey: "userArray") else {
            return []
        }
        let decoder = JSONDecoder()

        return (try? decoder.decode([BillItem].self, from: user)) ?? []
    }

    func savedBillAmount() -> AmountValue {
        guard let bill = UserDefaults.standard.data(forKey: "billAmount") else {
            return AmountValue(value: 0, currencyCode: "EUR")
        }
        let decoder = JSONDecoder()

        return (try? decoder.decode(AmountValue.self, from: bill)) ?? AmountValue(value: 0, currencyCode: "EUR")
    }

    func updateUsers(users: [BillItem]) {
        guard let data = try? JSONEncoder().encode(users) else { return }
        UserDefaults.standard.set(data, forKey: "userArray")
    }

    func updateBillAmount(billAmount: AmountValue) {
        guard let data = try? JSONEncoder().encode(billAmount) else { return }
        UserDefaults.standard.set(data, forKey: "billAmount")
    }
}
