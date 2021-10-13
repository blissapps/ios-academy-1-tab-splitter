//
//  AmountTextField.swift
//  Bliss_ex1
//
//  Created by Tiago Janela on 10/8/21.
//

import Foundation
import UIKit

public protocol AmountTextFieldDelegate: class {
    func amountDidChange(from: AmountTextField, amount: AmountValue?)
}

public class AmountTextField: UITextField {
    var coordinator: CoordinatorProtocol?
    var currencyPickerView: CurrencyPickerView?
    
    public weak var amountTextFieldDelegate: AmountTextFieldDelegate?

    public var selectedCurrency: String = "" {
        didSet {
            print(selectedCurrency)
        }
    }

    private var _amount: AmountValue?
    public var amount: AmountValue? {
        set {
            _amount = newValue
            updateWithAmount(newValue)
        }
        get {
            _amount
        }
    }
    
    private lazy var currencyButton: UIButton = {
        UIButton(type: .custom)
    }()

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        addSubview(currencyButton)
        currencyButton.frame = .init(x: 0, y: 0, width: 44, height: 44)
        currencyButton.addTarget(self, action: #selector(self.currencyButtonTouchUpInside), for: .touchUpInside)
        delegate = self
    }

    private func updateWithAmount(_ amount: AmountValue?) {
        text = amount.formatAmountForDisplay
        currencyButton.setTitle(amount?.currencyCode, for: .normal)
        currencyButton.setTitleColor(.black, for: .normal)
        selectedCurrency = amount?.currencyCode ?? ""
    }
    
    @objc func currencyButtonTouchUpInside() {
        currencyPickerView = CurrencyPickerView.showInKeyWindow()
        currencyPickerView?.currencies = ["EUR": 0.1, "USD": 0.2]
        currencyPickerView?.delegate = self
        //setup delegate
    }
}

extension AmountTextField: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }

    public func textFieldDidBeginEditing(_ textField: UITextField) {
        //textField.text?.removeAll(where: { $0 == "€" })
    }

    public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if text?.isEmpty == false {
            return true
        }
        return false
    }

    public func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        let amount = AmountValue.parse(text, selectedCurrency)
        _amount = amount
        amountTextFieldDelegate?.amountDidChange(from: self, amount: amount)
        endEditing(true)
    }
}

extension AmountTextField: CurrencyPickerViewDelegate {
    func currencyPickerView(_: CurrencyPickerView, didSelectCurrency currency: String?) {
        guard let currency = currency else {
            return
        }

        selectedCurrency = currency
    }
}

extension Optional where Wrapped == AmountValue {
    var formatAmountForDisplay: String {
        guard let amount = self else {
            return ""
        }
        return amount.formatAmountForDisplay
    }
}

extension  AmountValue {
    static func parse(_ text: String, _ currencyCode: String) -> AmountValue? {
        guard let amount = Decimal(string: text, locale: Locale.current) else {
            return nil
        }
        return AmountValue(amount: amount, currencyCode: currencyCode)
    }
    var formatAmountForDisplay: String {
        amount.displayFormat
    }
}
