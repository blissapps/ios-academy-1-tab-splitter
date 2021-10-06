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
    
    @IBOutlet weak private var nameTextField: UITextField!
    @IBOutlet weak private var valueTextField: UITextField!
    @IBOutlet weak private var saveOrAdd: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        nameTextField.delegate = self
        valueTextField.delegate = self
        
        dismissKeyboard()
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
        
        if coordinator?.selectedOption == .add {
            coordinator?.saveUser(BillItem(name: name, value: value, changedUser: nilValue))
        } else {
            guard let selectedUser = coordinator?.selectedUser else { return }
            var user = selectedUser
            user.name = name
            user.value = value
            user.changedUser = nilValue
            coordinator?.saveUser(user)
        }
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
            valueTextField.placeholder = "Insert the bill"
            nameTextField.placeholder = "Insert the name"
            return false
        }
    }
}
