//
//  VCCoordinator.swift
//  Bliss_ex1
//
//  Created by Filipe Santo on 30/09/2021.
//

import Foundation
import UIKit
import test

final class VCCoordinator: CoordinatorProtocol {
    var billEngine: BillSpliterEngine
    var navigationController: UINavigationController
    var delegate: CoordinatorDelegate?
    var selectedUser: BillItem?
    var selectedOption: OperationOption?
    
    var billAmount: AmountValue {
        billEngine.billAmount
    }
    
    var users: [BillItem] {
        billEngine.users
    }

    lazy var storyboard: UIStoryboard = {
        UIStoryboard.init(name: "Main", bundle: nil)
    }()

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        billEngine = BillSpliterEngine()
    }

    func selectUser(at index: Int) {
        selectedUser = billEngine.users[index]
        selectedOption = .save
        pushManageUserViewController(user: selectedUser)
    }

    func reset() {
        billEngine.reset()
        selectedUser = nil
        selectedOption = nil

        delegate?.updateRest(with: "\(billEngine.restAmount)")
        delegate?.updateTotal(with: "\(billEngine.billAmount.value)")
        delegate?.reloadData()
    }
    
    func start() {
        let vc = ViewController()
        vc.coordinator = self
        delegate = vc
        navigationController.setViewControllers([vc], animated: true)
    }

    func setBill(bill: Decimal) {
        billEngine.billAmount.value = bill
    }

    func add() {
        selectedOption = .add
        pushManageUserViewController(user: nil)
    }

    func back() {
        selectedUser = nil
        selectedOption = nil
        navigationController.popViewController(animated: true)
    }

    func saveUser(_ user: BillItem) {
        billEngine.saveUser(user)
        delegate?.reloadData()
        delegate?.updateRest(with: "\(billEngine.restAmount)€")
        selectedUser = nil
        selectedOption = nil
    }

    func setBillAmount(_ amount: AmountValue) {
        billEngine.billAmount.value = amount.value
        delegate?.updateTotal(with: billEngine.billAmount.value.displayAsCurrencyFormat)
        delegate?.updateRest(with: billEngine.restAmount.displayAsCurrencyFormat)
    }

    private func pushManageUserViewController(user: BillItem?) {
        let vc = SecondViewController()
            navigationController.pushViewController(vc, animated: true)
            vc.coordinator = self
            vc.changeTitleButton()
            vc.user = user
    }
}
