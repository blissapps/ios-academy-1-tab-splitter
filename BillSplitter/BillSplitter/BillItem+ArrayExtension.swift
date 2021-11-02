//
//  BillItem+ArrayExtension.swift
//  BillSplitterApp
//
//  Created by Tiago Janela on 10/4/21.
//
import Foundation

public extension Array where Element == BillItem {
    func contains(_ user: BillItem) -> Bool {
        first(where: { $0.id == user.id }) != nil
    }

    func user(with id: String) -> BillItem? {
        first(where: { $0.id == id })
    }

    mutating func save(user: BillItem) {
        if let index = firstIndex(where: { $0.id == user.id }) {
            remove(at: index)
            insert(user, at: index)
            return
        }
        append(user)
    }
}
