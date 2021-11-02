//
//  DiskBillEnginePersistence.swift
//  BillSplitterApp
//
//  Created by Tiago Janela on 11/2/21.
//

import Foundation
//
import AmountValue
import BillSplitter

class DiskBillEnginePersistence: BillEnginePersistenceProtocol {
    func savedUsers() -> [BillItem] {
        let fileManager = FileManager.default

        let folder = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)
        guard let fileURL = folder.first?.appendingPathComponent("users" + ".cache") else {
            return []
        }

        guard let data = try? Data(contentsOf: fileURL) else {
            return []
        }
        let decoder = JSONDecoder()

        return (try? decoder.decode([BillItem].self, from: data)) ?? []
    }

    func savedBillAmount() -> AmountValue {
        let fileManager = FileManager.default

        let folder = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)
        guard let fileURL = folder.first?.appendingPathComponent("billAmount" + ".cache") else {
            return AmountValue(value: 0, currencyCode: "EUR")
        }

        guard let data = try? Data(contentsOf: fileURL) else {
            return AmountValue(value: 0, currencyCode: "EUR")
        }
        let decoder = JSONDecoder()

        return (try? decoder.decode(AmountValue.self, from: data)) ?? AmountValue(value: 0, currencyCode: "EUR")
    }

    func updateUsers(users: [BillItem]) {
        let fileManager = FileManager.default

        let folder = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)

        guard  let fileURL = folder.first?.appendingPathComponent("users" + ".cache"),
               let data = try? JSONEncoder().encode(users) else {return}
        try? data.write(to: fileURL)
    }

    func updateBillAmount(billAmount: AmountValue) {
        let fileManager = FileManager.default

        let folder = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)

        guard  let fileURL = folder.first?.appendingPathComponent("billAmount" + ".cache"),
               let data = try? JSONEncoder().encode(billAmount) else {return}
        try? data.write(to: fileURL)
    }
}
