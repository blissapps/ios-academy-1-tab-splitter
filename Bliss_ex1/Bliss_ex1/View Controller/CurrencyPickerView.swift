//
//  CurrencyPickerView.swift
//  Bliss_ex1
//
//  Created by Filipe Santo on 08/10/2021.
//

import Foundation
import UIKit

class CurrencyPickerView: UIViewController {
    @IBOutlet weak var textField: UITextField!
    
    var coordinator: CoordinatorProtocol?
    var currencies : [String : Decimal]?
    var currencyPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = UIView(frame: CGRect.init(x: 0, y: 200, width: view.frame.width, height: 300))
        // Do any additional setup after loading the view.
        currencyPicker = UIPickerView.init(frame: CGRect.init(x: 0, y: 200, width: view.frame.width, height: 300))
        
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()

        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.donePicker))

        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        dismissKeyboard()
    }
}

//MARK:- Currency Picker Delegate & DataSource

extension CurrencyPickerView: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        currencies?.count ?? 0
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let currenciesName = currencies.map({$0.keys.description})
        return currenciesName
    }
    
    @objc func donePicker() {
        self.resignFirstResponder()
    }
}
