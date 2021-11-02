//
//  VCCoordinator.swift
//  BillSplitterApp
//
//  Created by Filipe Santo on 30/09/2021.
//

import Foundation
import UIKit
//
import AmountValue
import BillSplitter

final class VCCoordinator: CoordinatorProtocol {
    var billEngine: BillSplitterEngine
    var navigationController: UINavigationController
    var delegate: CoordinatorDelegate?
    var selectedUser: BillItem?
    var selectedOption: OperationOption?
    var persistence: BillEnginePersistenceProtocol?
    
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
        billEngine = BillSplitterEngine()
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
        setupCoordinatorPersistence()
        let vc = ViewController()
        vc.coordinator = self
        delegate = vc
        navigationController.setViewControllers([vc], animated: true)
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
        billEngine.users.save(user: user)
        delegate?.reloadData()
        delegate?.updateRest(with: "\(billEngine.restAmount)€")
        selectedUser = nil
        selectedOption = nil
    }

    func setBillAmount(_ amount: AmountValue) {
        billEngine.billAmount = amount
        delegate?.updateTotal(with: billEngine.billAmount.displayAsCurrencyFormat)
        delegate?.updateRest(with: billEngine.restAmount.displayAsCurrencyFormat)
    }

    private func pushManageUserViewController(user: BillItem?) {
        let vc = SecondViewController()
            navigationController.pushViewController(vc, animated: true)
            vc.coordinator = self
            vc.changeTitleButton()
            vc.user = user
    }

    func setupCoordinatorPersistence() {
        if FeatureFlags.shared.isUserDefaultsOn {
            persistence = UserDefaultsBillEnginePersistence()
        } else {
            persistence = DiskBillEnginePersistence()
        }
        if let billAmount = persistence?.savedBillAmount() {
            billEngine.billAmount = billAmount
        }
        if let users = persistence?.savedUsers() {
            billEngine.users = users
        }
        billEngine.usersDidChange = persistence?.updateUsers
        billEngine.billAmountDidChange = persistence?.updateBillAmount
    }
}
