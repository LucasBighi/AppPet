//
//  ModalViewController.swift
//  App-Pet
//
//  Created by Lucas Marques Bighi on 03/10/2019.
//  Copyright © 2019 Lucas Marques Bighi. All rights reserved.
//

import UIKit
import Foundation

protocol ModalViewControllerDelegate: NSObjectProtocol {
    
    var sender: TextFieldView {get}
    
    var componentsOfModal: [String] {get}
    
    func didSelectComponent()
}

class ModalViewController: UIViewController {
    
    weak var delegate: ModalViewControllerDelegate?
    var components = [""]
    var selectedComponent: String?
    private var isSearching = false
    private var isSelected = false
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchBarHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var pickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    var errorMessage: String = ""{
        didSet {
            errorLabel.text = errorMessage
        }
    }
    
    func setupView() {
        errorLabel.text = errorMessage
        view.backgroundColor = .clear
        view.isOpaque = false
        searchBar.delegate = self
        selectedComponent = delegate?.sender.text
        if let components = delegate?.componentsOfModal {
            self.components = components
            if let offSet = components.firstIndex(where: {$0 == selectedComponent}) {
                pickerView.selectRow(offSet, inComponent: 0, animated: true)
            } else {
                pickerView.selectRow(0, inComponent: 0, animated: true)
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        pickerView.reloadAllComponents()
    }
    
    @IBAction func searchAction(_ sender: UIButton) {
        isSearching = !isSearching
        UIView.animate(withDuration: 0.2) {
            if self.isSearching {
                self.searchBarHeightConstraint.constant = 50
            } else {
                self.searchBarHeightConstraint.constant = 0
            }
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func okAction(_ sender: UIButton) {
        selectedComponent = components[pickerView.selectedRow(inComponent: 0)]
        delegate?.didSelectComponent()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backgroundAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension ModalViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return components.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return components[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedComponent = components[row]
        delegate?.didSelectComponent()
    }
}

extension ModalViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let components = delegate?.componentsOfModal, searchText != "" {
            let filtered = components.filter {$0.contains(searchText)}
            if filtered.isEmpty {
                errorMessage = "Nenhum resultado encontrado"
            } else {
                errorMessage = ""
            }
            self.components = filtered
        }
        pickerView.reloadAllComponents()
        pickerView.selectRow(0, inComponent: 0, animated: true)
    }
}
