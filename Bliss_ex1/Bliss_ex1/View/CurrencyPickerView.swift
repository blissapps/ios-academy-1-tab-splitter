//
//  CurrencyPickerView.swift
//  Bliss_ex1
//
//  Created by Filipe Santo on 08/10/2021.
//

import Foundation
import UIKit

protocol CurrencyPickerViewDelegate: AnyObject {
    func currencyPickerView(_: CurrencyPickerView, didSelectCurrency currency: String?)
}

class CurrencyPickerView: UIView {
    @IBOutlet weak var textField: UITextField!
    weak var delegate: CurrencyPickerViewDelegate?

    var coordinator: CoordinatorProtocol?
    var currencies : [String]? {
        didSet {
            currencyPicker?.reloadAllComponents()
            
            if let currency =  selectedCurrency {
                let index = sortedCurrencies.firstIndex(of: currency)
                currencyPicker?.selectRow(index ?? 0, inComponent: 0, animated: false)
            } 
        }
    }
    var currencyPicker: UIPickerView?
    var toolBar: UIToolbar?

    var selectedCurrency: String?

    var sortedCurrencies: [String] {
        currencies?.sorted() ?? []
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        currencyPicker = UIPickerView()
        guard let currencyPicker = currencyPicker else {
            return
        }

        currencyPicker.delegate = self
        currencyPicker.dataSource = self
        addSubview(currencyPicker)
        
        currencyPicker.backgroundColor = .white
        
        toolBar = UIToolbar()
        toolBar?.barStyle = UIBarStyle.default
        toolBar?.isTranslucent = true
        toolBar?.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar?.sizeToFit()

        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.donePicker))

        toolBar?.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar?.isUserInteractionEnabled = true
        guard let toolBar = toolBar else {
            return
        }
                
        addSubview(toolBar)
    }

    fileprivate func positionInWindow() {
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        frame = .init(x: 0, y: window.frame.height - 300, width: window.frame.width, height: 300)
        toolBar?.frame = .init(x: 0, y: 0, width: window.frame.width, height: 40)
        currencyPicker?.frame = .init(x: 0, y: 40, width: window.frame.width, height: 260)
    }
}

extension CurrencyPickerView {
    static func showInKeyWindow() -> CurrencyPickerView? {
        guard let window = UIApplication.shared.keyWindow else {
            return nil
        }
        let currencyPickerView = CurrencyPickerView()
        window.addSubview(currencyPickerView)
        currencyPickerView.positionInWindow()
        return currencyPickerView
    }
}

//MARK: - Currency Picker Delegate & DataSource

extension CurrencyPickerView: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        sortedCurrencies.count
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCurrency = sortedCurrencies.count > row ? sortedCurrencies[row] : nil
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        sortedCurrencies[row]
    }
    
    @objc func donePicker() {
        delegate?.currencyPickerView(self, didSelectCurrency: selectedCurrency)
        removeFromSuperview()
    }
}
