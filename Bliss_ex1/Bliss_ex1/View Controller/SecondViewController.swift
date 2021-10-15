//
//  SecondViewController.swift
//  Bliss_ex1
//
//  Created by Filipe Santo on 29/09/2021.
//

import UIKit

extension String {
    var localized: String {
        NSLocalizedString(self, comment: self)
    }
}

class SecondViewController: UIViewController {

    var coordinator: CoordinatorProtocol?
    
    private var nameTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.placeholder = "insert_name".localized
        return textField
    }()

    @IBOutlet weak private var valueTextField: AmountTextField = {
        let textField = AmountTextField()
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.placeholder = "insert_value".localized
        return textField
    }()
    
    @IBOutlet weak private var saveOrAdd: UIButton!
    
    var user: BillItem? {
        didSet {
            configScreen()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        valueTextField.coordinator = coordinator

        nameTextField.delegate = self
        valueTextField.delegate = self
        
        dismissKeyboard()
    }
    
    private func configScreen() {
        nameTextField.text = user?.name
        valueTextField.text = user?.value?.amount.description
    }
    
    func changeTitleButton() {
        _ = view
        if coordinator?.selectedOption == .add {
            saveOrAdd.setTitle("add_button_title".localized, for: .normal)
        } else {
            saveOrAdd.setTitle("save_button_title".localized, for: .normal)
        }
    }
    
    @IBAction func back(_ sender: Any) {
        coordinator?.back()
    }
    
    @IBAction func didTapButton(_ sender: Any) {
        var nilValue = false
        
        if valueTextField.text != "" {
            nilValue = true
        }
        
        let valueAsString = valueTextField.text?.replacingOccurrences(of: ",", with: ".") ?? "0"
        
        let value = Decimal(string: valueAsString, locale: Locale.current) ?? 0
        let name = nameTextField.text ?? ""
        let amountValue = AmountValue(amount: value, currencyCode: "")
        
        if coordinator?.selectedOption == .add {
            coordinator?.saveUser(BillItem(name: name, value: amountValue, changedUser: nilValue))
        } else {
            guard let selectedUser = coordinator?.selectedUser else { return }
            var user = selectedUser
            user.name = name
            user.value = amountValue
            user.changedUser = nilValue
            coordinator?.saveUser(user)
        }
        user = nil
        coordinator?.back()
    }
    
}

//MARK: - UITextFieldDelegate

extension SecondViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text?.isEmpty == false {
            return true
        } else {
            valueTextField.placeholder = "insert_bill".localized
            nameTextField.placeholder = "insert_name".localized
            return false
        }
    }
}
