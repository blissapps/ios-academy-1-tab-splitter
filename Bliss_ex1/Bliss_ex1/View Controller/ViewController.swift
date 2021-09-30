//
//  ViewController.swift
//  Bliss_ex1
//
//  Created by Filipe Santo on 29/09/2021.
//

import UIKit

class ViewController: UIViewController {
    var users: [BillItem]?
    var bill: Double?
    var coordinator: Coordinator?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var restLabel: UILabel!
    @IBOutlet weak var totalLabel: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        totalLabel.delegate = self
        
        self.dismissKeyboard()
    }
    
    @IBAction func restartButton(_ sender: Any) {
        coordinator?.delete()
    }
    
    @IBAction func addButton(_ sender: Any) {
        coordinator?.uptade(int: 0)
    }
}


//MARK: - TableView

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Row selected")
        if let index = tableView.indexPathsForSelectedRows?.first?.dropFirst() {
            coordinator?.setIndex(index: index)
        }
        coordinator?.uptade(int: 1)
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
        //return coordinator?.billItems?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = users?[indexPath.row].name

 //       String(users?[indexPath.row].value ?? 0)
        return cell
    }
    
}

//MARK: - UITextFieldDelegate

extension ViewController: UITextFieldDelegate {
    @IBAction func searchPressed(_ sender: Any) {
        if let bill = Double(totalLabel.text ?? "0") {
            view.endEditing(true)
            totalLabel.text = String(bill) + "€"
            coordinator?.setBill(bill: self.bill ?? 0)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if totalLabel.text != "" {
            return true
        } else {
            totalLabel.placeholder = "Insert the bill"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let bill = Double(totalLabel.text ?? "0"){
            view.endEditing(true)
            totalLabel.text = String(bill) + "€"
            coordinator?.setBill(bill: self.bill ?? 0)
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



