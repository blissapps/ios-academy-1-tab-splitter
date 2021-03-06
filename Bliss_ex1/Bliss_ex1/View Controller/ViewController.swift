//
//  ViewController.swift
//  Bliss_ex1
//
//  Created by Filipe Santo on 29/09/2021.
//

import UIKit
import SnapKit
import test

class ViewController: UIViewController {
    var coordinator: CoordinatorProtocol?
        
    var currencies: [String:Decimal] = [:]
    
    private var tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    private var restLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = UIFont.systemFont(ofSize: 33)
        label.textAlignment = .center
        return label
    }()
    
    private var vStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()
    
    private var totalTextField: AmountTextField = {
        let textField = AmountTextField()
        textField.font = UIFont.systemFont(ofSize: 48)
        textField.textAlignment = .center
        return textField
    }()
    
    private var totalErrorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("add_button_title".localized, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.setTitleColor(.systemBlue, for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 100, height: 44)
        return button
    }()
    
    private lazy var restartButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Restart", for: .normal)
        button.titleLabel?.font = UIFont(name: "AccentColor", size: 20)
        return button
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Tab Splitter"
        
        view.addSubview(tableView)
        view.addSubview(vStackView)
        
        view.backgroundColor = .white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(restartButtonTouchUpInside))
        
        tableView.tableFooterView = addButton
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "tableViewCell")
        
        vStackView.addArrangedSubview(totalTextField)
        vStackView.addArrangedSubview(restLabel)
        vStackView.addArrangedSubview(totalErrorLabel)
        
        addButton.addTarget(self, action: #selector(self.addButtonTouchUpInside), for: .touchUpInside)
        restartButton.addTarget(self, action: #selector(self.restartButtonTouchUpInside), for: .touchUpInside)
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
        }
        
        totalTextField.snp.makeConstraints {make in
            make.height.equalTo(120)
            make.leading.trailing.equalToSuperview()
        }
        
        vStackView.snp.makeConstraints { make in
            make.height.equalTo(250)
            make.leading.trailing.bottom.equalToSuperview().inset(40)
            make.top.equalTo(tableView.snp.bottom)
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        
        totalErrorLabel.isHidden = true
        totalTextField.placeholder = "amount_text_field_placeholder".localized
        
        totalTextField.amount = coordinator?.billAmount
        totalTextField.coordinator = coordinator
        totalTextField.amountTextFieldDelegate = self
        
        self.dismissKeyboard()
    }
    
    @objc func restartButtonTouchUpInside() {
        coordinator?.reset()
    }
    
    @objc func addButtonTouchUpInside() {
        coordinator?.add()
    }
}

//MARK: - Amount Text Field Delegate

extension ViewController: AmountTextFieldDelegate {
    func amountDidChange(from: AmountTextField, amount: AmountValue?) {
        guard let amount = amount else {
            print("no amount")
            return
        }
        coordinator?.setBillAmount(amount)
    }
}

//MARK: - Coordinator Delegate

extension ViewController: CoordinatorDelegate {
    func reloadData() {
        tableView.reloadData()
    }
    
    func updateRest(with text: String) {
        restLabel.text = text
    }
    
    func updateTotal(with text: String) {
        totalTextField.text = text
        totalErrorLabel.isHidden = true
    }

    func displayBillAmountError() {
        totalErrorLabel.isHidden = false
        totalErrorLabel.text = "bill_amount_invalid_error_text".localized
    }
}

//MARK: - TableView

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        coordinator?.selectUser(at: indexPath.row)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coordinator?.users.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        var cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath)
        if cell == nil || cell.detailTextLabel == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "tableViewCell")
        }
        
        let user = coordinator?.users[indexPath.row]
        cell.textLabel?.text = user?.name
        cell.detailTextLabel?.text = user?.amount?.formatAmountForDisplay ?? "N.A."
        cell.textLabel?.textColor = .black
        cell.detailTextLabel?.textColor = .black
        return cell
    }
}

//MARK: - UITextFieldDelegate

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text?.removeAll(where: { $0 == "???" })
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if totalTextField.text?.isEmpty == false {
            return true
        }
        
        totalTextField.placeholder = "insert_bill".localized
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        view.endEditing(true)
    }
}

//MARK: - Touch

extension UIViewController {
func dismissKeyboard() {
       let tap: UITapGestureRecognizer = UITapGestureRecognizer( target:     self, action:    #selector(UIViewController.dismissKeyboardTouchOutside))
       tap.cancelsTouchesInView = false
       view.addGestureRecognizer(tap)    }
    
    @objc private func dismissKeyboardTouchOutside() {
       view.endEditing(true)
    }
}
