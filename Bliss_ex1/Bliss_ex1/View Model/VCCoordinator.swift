//
//  VCCoordinator.swift
//  Bliss_ex1
//
//  Created by Filipe Santo on 30/09/2021.
//

import Foundation
import UIKit

final class VCCoordinator: CoordinatorProtocol {
    var billEngine: BillSpliterEngine
    var navigationController: UINavigationController
    var delegate: CoordinatorDelegate?
    var selectedUser: BillItem?
    var selectedOption: OperationOption?
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
        pushManageUserViewController()
    }

    func reset() {
        billEngine.reset()
        selectedUser = nil
        selectedOption = nil

        delegate?.updateRest(with: "\(billEngine.restAmount)€")
        delegate?.updateTotal(with: "\(billEngine.billAmount)€")
        delegate?.reloadData()
    }

    func setBill(bill: Decimal) {
        billEngine.billAmount = bill
    }

    func add() {
        selectedOption = .add
        pushManageUserViewController()
    }

    func back() {
        selectedUser = nil
        selectedOption = nil
        navigationController.popViewController(animated: true)
    }

    func saveUser(_ user: BillItem) {
        billEngine.saveUser(user)
        delegate?.reloadData()
        selectedUser = nil
        selectedOption = nil
    }

    func billAmountDidChange(_ value: Decimal) {
        billEngine.billAmount = value
    }

    private func pushManageUserViewController() {
        if let vc = storyboard.instantiateViewController(withIdentifier: "SecondViewController") as? SecondViewController {
            navigationController.pushViewController(vc, animated: true)
            vc.coordinator = self
            vc.changeTitleButton()
        }
    }
}
