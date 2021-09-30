//
//  SVCViewModel.swift
//  Bliss_ex1
//
//  Created by Filipe Santo on 30/09/2021.
//

import Foundation

struct BillItem {}

protocol Coordinator {
    var selectedBillItem: BillItem? { get set }
    var billItems: [BillItem]? { get set }
    func delete()
    func uptade(int: Int)
}

