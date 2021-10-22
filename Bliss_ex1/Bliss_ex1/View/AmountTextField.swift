//
//  AmountTextField.swift
//  Bliss_ex1
//
//  Created by Tiago Janela on 10/8/21.
//

import Foundation
import UIKit
import SnapKit

public protocol AmountTextFieldDelegate: AnyObject {
    func amountDidChange(from: AmountTextField, amount: AmountValue?)
}

public class AmountTextField: UITextField {
    var coordinator: CoordinatorProtocol?
    var currencyPickerView: CurrencyPickerView?
    
    public weak var amountTextFieldDelegate: AmountTextFieldDelegate?

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
    
    public init() {
        super.init(frame: .zero)
        commonInit()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        rightView = currencyButton
        rightViewMode = .always
        currencyButton.addTarget(self, action: #selector(self.currencyButtonTouchUpInside), for: .touchUpInside)
        currencyButton.setTitleColor(.black, for: .normal)
        delegate = self
    }

    private func updateWithAmount(_ amount: AmountValue?) {
        text = amount.formatAmountValueForDisplay
        currencyButton.setTitle(amount?.currencyCode, for: .normal)
    }
    
    @objc func currencyButtonTouchUpInside() {
        currencyPickerView = CurrencyPickerView.showInKeyWindow()
        currencyPickerView?.selectedCurrency = amount?.currencyCode
        currencyPickerView?.currencies = coordinator?.latestCurrencies
        currencyPickerView?.delegate = self
    }
}

extension AmountTextField: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }

    public func textFieldDidBeginEditing(_ textField: UITextField) {
    }

    public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if text?.isEmpty == false {
            return true
        }
        return false
    }

    public func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        let amount = AmountValue.parse(text, _amount?.currencyCode ?? "EUR")
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
        let value = DecimalParser.parseDecimalString(text ?? "")
        let newAmount = (amount ?? AmountValue(value: value.extractedValue ?? 0, currencyCode: currency)) >>> currency
        self.amount = newAmount
    }
}

extension Optional where Wrapped == AmountValue {
    var formatAmountValueForDisplay: String {
        guard let amount = self else {
            return ""
        }
        return amount.formatAmountValueForDisplay
    }

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
        return AmountValue(value: amount, currencyCode: currencyCode)
    }
    var formatAmountValueForDisplay: String {
        value.displayFormat
    }

    var formatAmountForDisplay: String {
        "\(value.displayFormat) \(currencyCode)"
    }
}
