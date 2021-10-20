//
//  SecondViewController.swift
//  Bliss_ex1
//
//  Created by Filipe Santo on 29/09/2021.
//

import UIKit
import SnapKit

extension String {
    var localized: String {
        NSLocalizedString(self, comment: self)
    }
}

class SecondViewController: UIViewController {

    var coordinator: CoordinatorProtocol?
    
    private var vStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
    
        return stackView
    }()
    
    private var nameTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.placeholder = "insert_name".localized
        return textField
    }()

    private var valueTextField: AmountTextField = {
        let textField = AmountTextField()
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.placeholder = "insert_bill".localized
        return textField
    }()
    
    private lazy var saveOrAdd: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("add_button_title".localized, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 22)
        button.setTitleColor(.systemBlue, for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 100, height: 44)
        return button
    }()
    
    private lazy var backButton: UIBarButtonItem? = {
        let button = self.navigationController?.navigationBar.topItem?.backBarButtonItem
        return button
    }()
    
    var user: BillItem? {
        didSet {
            configScreen()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = saveOrAdd.currentTitle
        
        view.addSubview(vStackView)
        view.addSubview(saveOrAdd)
        
        view.backgroundColor = .white
        
        vStackView.addArrangedSubview(nameTextField)
        vStackView.addArrangedSubview(valueTextField)
        
        valueTextField.coordinator = coordinator

        nameTextField.delegate = self
        valueTextField.delegate = self
        
        saveOrAdd.addTarget(self, action: #selector(self.didTapButton), for: .touchUpInside)
        backButton?.perform(#selector(self.back))
        
        vStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().offset(30)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        
        saveOrAdd.snp.makeConstraints{make in
            make.top.equalTo(vStackView.snp.bottom)
            make.leading.equalTo(150)
        }
        dismissKeyboard()
    }
    
    private func configScreen() {
        nameTextField.text = user?.name
        valueTextField.text = user?.amount?.value.description
    }
    
    func changeTitleButton() {
        _ = view
        if coordinator?.selectedOption == .add {
            saveOrAdd.setTitle("add_button_title".localized, for: .normal)
        } else {
            saveOrAdd.setTitle("save_button_title".localized, for: .normal)
        }
    }
    
    @objc func back(_ sender: Any) {
        coordinator?.back()
    }
    
    @objc func didTapButton(_ sender: Any) {
        var nilValue = false
        
        if valueTextField.text != "" {
            nilValue = true
        }
        
        let valueAsString = valueTextField.text?.replacingOccurrences(of: ",", with: ".") ?? "0"
        
        let value = Decimal(string: valueAsString, locale: Locale.current) ?? 0
        let name = nameTextField.text ?? ""
        let amountValue = AmountValue(value: value, currencyCode: "")
        
        if coordinator?.selectedOption == .add {
            coordinator?.saveUser(BillItem(name: name, amount: amountValue, changedUser: nilValue))
        } else {
            guard let selectedUser = coordinator?.selectedUser else { return }
            var user = selectedUser
            user.name = name
            user.amount = amountValue
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
