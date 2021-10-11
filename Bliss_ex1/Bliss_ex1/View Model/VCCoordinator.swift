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
    
    var latestCurrencies: [String : Decimal]? {
        billEngine.latest?.rates
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
        delegate?.updateRest(with: "\(billEngine.restAmount)€")
        selectedUser = nil
        selectedOption = nil
    }

    func setBillAmount(_ value: Decimal) {
        billEngine.billAmount = value
        delegate?.updateTotal(with: billEngine.billAmount.displayAsCurrencyFormat)
        delegate?.updateRest(with: billEngine.restAmount.displayAsCurrencyFormat)
    }

    func setBillAmount(_ value: String) {
        let result = DecimalParser.parseDecimalString(value)
        switch result {
        case .failure:
            delegate?.displayBillAmountError()
        case .success(let billAmount):
            setBillAmount(billAmount)
        }
    }

    private func pushManageUserViewController() {
        if let vc = storyboard.instantiateViewController(withIdentifier: "SecondViewController") as? SecondViewController {
            navigationController.pushViewController(vc, animated: true)
            vc.coordinator = self
            vc.changeTitleButton()
        }
    }
    
    private func goToCurrencyPickerScreen() {
        guard let vc = storyboard.instantiateViewController(withIdentifier: "CurrencyPickerViewController") as? CurrencyPickerView,
              let originVC = navigationController.topViewController as? ViewController else {
            return
        }
        
        navigationController.pushViewController(vc, animated: true)
        vc.coordinator = self
        vc.currencies = originVC.currencies
    }
}
