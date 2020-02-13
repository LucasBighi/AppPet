//
//  TextFieldView.swift
//  App-Pet
//
//  Created by Lucas Marques Bighi on 26/08/2019.
//  Copyright © 2019 Lucas Marques Bighi. All rights reserved.
//

import UIKit

protocol TextFieldViewDelegate: NSObjectProtocol {
    
    var callerView: UIViewController {get}
    
    func changeAction(sender: TextFieldView)
}

@IBDesignable
class TextFieldView: UIView, NibLoadable {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var placeholderLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var bottomLine: UIView!
    @IBOutlet weak var placeholderTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var errorLabel: UILabel!
    
    private let toolbar = UIToolbar()
    private var pickerView = UIPickerView()
//    var activeField: TextFieldView!
    weak var delegate: TextFieldViewDelegate?
    var componentsArray: [String]?
    var datePicker = UIDatePicker()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    private func setup() {
        self.setupFromNib()
        setupComponents()
        textField.delegate = self
        pickerView.delegate = self
        //modalView.delegate = self
        //activeField = self
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        //modalView.modalPresentationStyle = .overCurrentContext
        //modalView.selectedComponent = text
        bottomLine.layer.borderWidth = 0.4
        setupToolbar()
        setupDatePicker()
    }
    
    func setupComponents(with components: [String] = [String]()) {
        if !components.isEmpty {
            self.componentsArray = components
            textField.inputAccessoryView = toolbar
            textField.inputView = pickerView
        }
    }
    
    private func setupToolbar() {
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "OK", style: .plain, target: self, action: #selector(done))
        doneButton.tintColor = .purple
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancelar", style: .plain, target: self, action: #selector(cancel))
        cancelButton.tintColor = .purple
        toolbar.setItems([cancelButton, space, doneButton], animated: false)
    }
    
    func setupDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.locale = Time.current.locale
    }
    
    @objc func done() {
        if isDate {
            textField.text = Time.current.formatDate(date: datePicker.date, format: .fullDate)
        }
        if componentsArray != nil{
            textField.text = componentsArray?[pickerView.selectedRow(inComponent: 0)]
        }
        dismissDatePicker()
    }
    
    @objc func cancel() {
        dismissDatePicker()
    }
    
    func dismissDatePicker() {
        self.contentView.endEditing(true)
        //self.view.endEditing(true)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        text = textField.text!
        //delegate?.changeAction(sender: self)
    }
    
    @IBInspectable var placeholder: String = "" {
        didSet {
            placeholderLabel.text = placeholder
        }
    }
    
    @IBInspectable var text: String = "" {
        didSet {
            textField.text = text
            if text != "" {
                switchPlaceholder(isActive: true)
            }
        }
    }
    
    @IBInspectable var isEmail: Bool = false {
        didSet {
            if isEmail {
                textField.keyboardType = .emailAddress
            }
        }
    }
    
    @IBInspectable var isPassword: Bool = false {
        didSet {
            textField.isSecureTextEntry = isPassword
        }
    }
    
    @IBInspectable var isNumber: Bool = false {
        didSet {
            if isNumber {
                textField.keyboardType = .numberPad
            }
        }
    }
    
    @IBInspectable var isDate: Bool = false {
        didSet {
            if isDate {
                textField.inputAccessoryView = toolbar
                textField.inputView = datePicker
            }
        }
    }
    
    @IBInspectable var maxChars: Int = 0
    
    @IBInspectable var components: String = "" {
        didSet {
            componentsArray = components.split{$0 == ","}.map(String.init)
        }
    }
    
    @IBInspectable var textColor: UIColor = .darkGray {
        didSet {
            textField.textColor = textColor
        }
    }
    
    @IBInspectable var placeholderColor: UIColor = .lightGray {
        didSet {
            placeholderLabel.textColor = placeholderColor
        }
    }
    
    @IBInspectable var bottomLineColor: UIColor = .lightGray {
        didSet {
            bottomLine.layer.borderColor = self.bottomLineColor.cgColor
        }
    }
    
    @IBInspectable var activePlaceholderColor: UIColor = .darkGray
    
    @IBInspectable var activeBottomLineColor: UIColor = .purple
    
    var errorMessage: String = "" {
        didSet {
            errorLabel.text = errorMessage
        }
    }
    
    func switchPlaceholder(isActive: Bool) {
        UIView.animate(withDuration: 0.2) {
            if isActive {
                self.placeholderTopConstraint.constant = 0
                self.placeholderLabel.font = UIFont.systemFont(ofSize: 12)
                self.placeholderLabel.textColor = self.activePlaceholderColor
                self.bottomLine.layer.borderWidth = 1
                self.bottomLine.layer.borderColor = self.activeBottomLineColor.cgColor
                self.contentView.layoutIfNeeded()
            } else {
                self.placeholderTopConstraint.constant = 13
                self.placeholderLabel.font = UIFont.systemFont(ofSize: 15)
                self.placeholderLabel.textColor = self.placeholderColor
                self.bottomLine.layer.borderWidth = 0.4
                self.bottomLine.layer.borderColor = self.bottomLineColor.cgColor
                self.contentView.layoutIfNeeded()
            }
        }
    }
    
    func lostFocus(_ force: Bool) {
        self.contentView.endEditing(force)
    }
    
    @IBAction func editingDidBegin(_ sender: UITextField) {
        if components != "" {
//            modalView.components = componentsArray
//            delegate?.callerView.present(modalView, animated: true)
        }
        switchPlaceholder(isActive: true)
    }
    
    @IBAction func editingDidEnd(_ sender: UITextField) {
        if sender.text == "" {
            switchPlaceholder(isActive: false)
        }
    }
}

extension TextFieldView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //delegate?.changeAction(sender: activeField)
    }
}

//extension TextFieldView: ModalViewControllerDelegate {
//    var sender: TextFieldView {
//        return self
//    }
//
//    var componentsOfModal: [String] {
//        return componentsArray
//    }
//
//    func didSelectComponent() {
//        if let text = modalView.selectedComponent {
//            self.text = text
//        }
//    }
//}

extension TextFieldView: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return componentsArray?.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return componentsArray?[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        textField.text = componentsArray?[row]
    }
}
