//
//  SVCViewModel.swift
//  BillSplitterApp
//
//  Created by Filipe Santo on 30/09/2021.
//

import Foundation
//
import AmountValue
import BillSplitter

enum OperationOption {
    case save
    case add
}

protocol CoordinatorDelegate: AnyObject {
    func reloadData()
    func displayBillAmountError()
    func updateRest(with rest: AmountValue)
    func updateTotal(with value: AmountValue)
}

protocol CoordinatorProtocol: AnyObject {
   
    var delegate: CoordinatorDelegate? { get set }
    var selectedUser: BillItem? { get }
    var selectedOption: OperationOption? { get }
    var users: [BillItem] { get }
    var billAmount: AmountValue { get }
    
    func setBillAmount(_ amount: AmountValue)
    func selectUser(at index: Int)
    func saveUser(_ user: BillItem)
    func add()
    func back()
    func reset()
    func start()
}
