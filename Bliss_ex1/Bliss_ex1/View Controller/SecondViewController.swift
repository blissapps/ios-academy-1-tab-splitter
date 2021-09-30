//
//  SecondViewController.swift
//  Bliss_ex1
//
//  Created by Filipe Santo on 29/09/2021.
//

import UIKit

class SecondViewController: UIViewController {

    var coordinator: Coordinator?
    
    var name: String?
    var value: Double?
    
    @IBAction func back(_ sender: Any) {}
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var valueTextField: UITextField!
    
    @IBOutlet weak var adicionarOuSalvar: UIButton!
    
    @IBAction func adicionarOuSalvarAction(_ sender: Any) {
        coordinator?.addPerson(name: name ?? "", value: value ?? 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        nameTextField.delegate = self
        valueTextField.delegate = self
        
        self.dismissKeyboard()
    }
/*
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let billItem = coordinator?.selectedBillItem else {
            changeTitleButton(int: 0)
            return
        }
        changeTitleButton(int: 1)
        //nameTextField.text = billItem.name
    }
*/
    func changeTitleButton(int: Int) {
        _ = view
        if(int == 0) {
            adicionarOuSalvar.setTitle("Adicionar", for: .normal)
        } else {
            adicionarOuSalvar.setTitle("Salvar", for: .normal)
        }
    }
}

//MARK: - UITextFieldDelegate

extension SecondViewController: UITextFieldDelegate {
    @IBAction func searchPressed(_ sender: Any) {
        if let value = Double(valueTextField.text ?? "0") {
            view.endEditing(true)
            valueTextField.text = String(value)
        }
        if let name = Double(nameTextField.text ?? "0") {
            view.endEditing(true)
            nameTextField.text = String(name)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if valueTextField.text != "" {
            return true
        } else {
            valueTextField.placeholder = "Insert the bill"
            nameTextField.placeholder = "Insert the name"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let value = Double(valueTextField.text ?? "0"){
            view.endEditing(true)
            valueTextField.text = String(value)
        }
        if let name = Double(nameTextField.text ?? "0") {
            view.endEditing(true)
            nameTextField.text = String(name)
        }
    }
}
