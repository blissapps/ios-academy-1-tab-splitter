//
//  ViewController.swift
//  Bliss_ex1
//
//  Created by Filipe Santo on 29/09/2021.
//

import UIKit

class ViewController: UIViewController {
    var coordinator: CoordinatorProtocol?
    
    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak private var restLabel: UILabel!
    @IBOutlet weak private var totalTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        totalTextField.delegate = self
        
        self.dismissKeyboard()
    }
    
    @IBAction func restartButton(_ sender: Any) {
        coordinator?.reset()
    }
    
    @IBAction func addButton(_ sender: Any) {
        coordinator?.add()
        
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
    }
    
    func next() {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "SecondViewController") as? SecondViewController {
            navigationController?.pushViewController(vc, animated: true)
            vc.coordinator = coordinator
            vc.changeTitleButton()
        }
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let user = coordinator?.users[indexPath.row]
        cell.textLabel?.text = user?.name
        cell.detailTextLabel?.text = "\((user?.value ?? 0).description)€"
        return cell
    }
    
}

//MARK: - UITextFieldDelegate

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text?.removeAll(where: { $0 == "€" })
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if totalTextField.text?.isEmpty == false {
            return true
        }
        
        totalTextField.placeholder = "Insert the bill"
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text?.replacingOccurrences(of: ",", with: "."),
           var billAmount = Decimal(string: text , locale: .current) {
            let formattedText = (billAmount.roundToPlaces(places: 2).description).replacingOccurrences(of: ".", with: Locale.current.decimalSeparator ?? ",")
            view.endEditing(true)
            totalTextField.text = "\(formattedText)€"
            coordinator?.billAmountDidChange(billAmount)
        }
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



