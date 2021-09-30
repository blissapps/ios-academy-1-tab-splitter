//
//  SecondViewController.swift
//  Bliss_ex1
//
//  Created by Filipe Santo on 29/09/2021.
//

import UIKit

class SecondViewController: UIViewController {
    
    @IBAction func back(_ sender: Any) {}
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var valueTextField: UITextField!
    
    @IBOutlet weak var adicionarOuSalvar: UIButton!
    @IBAction func adicionarOuSalvarAction(_ sender: Any) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        nameTextField.delegate = self
        valueTextField.delegate = self
    }

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
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true 
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Type something"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
    }
}
