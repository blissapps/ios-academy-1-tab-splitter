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

    public var selectedCurrency: String = "" {
        didSet {
            currencyButton.setTitle(selectedCurrency, for: .normal)
            coordinator?.setCurrencyCode(selectedCurrency)
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
    
    override public func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override public var intrinsicContentSize: CGSize{
        let size = super.intrinsicContentSize
        print(size)
        return size
    }

    public override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        let buttonSize = rightView?.intrinsicContentSize ?? .zero
       
        return CGRect(x: frame.width - buttonSize.width, y: 0, width: buttonSize.width, height: buttonSize.height)
    }
    
    public override func textRect(forBounds bounds: CGRect) -> CGRect {
        let buttonSize = rightView?.intrinsicContentSize ?? .zero
        return CGRect(x: 0, y: 0, width: frame.width - buttonSize.width, height: frame.height)
    }
    
    private func commonInit() {
        rightView = currencyButton
        rightViewMode = .always
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
        let newAmount = (amount ?? AmountValue(value: 0, currencyCode: "EUR")) >>> currency
        self.amount = newAmount
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
        return AmountValue(value: amount, currencyCode: currencyCode)
    }
    var formatAmountForDisplay: String {
        value.displayFormat
    }
}
