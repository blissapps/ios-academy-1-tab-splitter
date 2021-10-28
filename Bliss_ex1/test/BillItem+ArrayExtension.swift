//
//  BillItem+ArrayExtension.swift
//  Bliss_ex1
//
//  Created by Tiago Janela on 10/4/21.
//
import Foundation

extension Array where Element == BillItem {
    func contains(_ user: BillItem) -> Bool {
        first(where: { $0.id == user.id }) != nil
    }

    func user(with id: String) -> BillItem? {
        first(where: { $0.id == id })
    }

    mutating func replace(id: String, user: BillItem) {
        guard let index = firstIndex(where: { $0.id == id }) else {
            return
        }
        remove(at: index)
        insert(user, at: index)
    }
}
