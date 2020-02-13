//
//  EditPetInfosViewController.swift
//  App-Pet
//
//  Created by Lucas Marques Bighi on 05/11/2019.
//  Copyright © 2019 Lucas Marques Bighi. All rights reserved.
//

import UIKit

class EditPetInfosViewController: UIViewController {
    
    private let segueIdentifier = "petImageSegue"
    
    var petName: String?
    
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var buttonBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var savePetActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var typeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var genderSegmentedControl: UISegmentedControl!
    @IBOutlet weak var breedTextFieldView: TextFieldView!
    @IBOutlet weak var borndDateTextFieldView: TextFieldView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        labelName.text = petName
        headerView.layer.cornerRadius = 20
        if let breeds = loadJson(fileName: "Breeds") {
            breedTextFieldView.setupComponents(with: breeds)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.tabBarController?.tabBar.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        guard let animationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber else { return }
        let keyboardHeight: CGFloat
        if #available(iOS 11, *) {
            keyboardHeight = keyboardFrame.cgRectValue.height - self.view.safeAreaInsets.bottom
        } else {
            keyboardHeight = keyboardFrame.cgRectValue.height
        }
        UIView.animate(withDuration: animationDuration.doubleValue) {
            self.buttonBottomConstraint.constant = keyboardHeight + 40
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        buttonBottomConstraint.constant = 40
    }
    
    @IBAction func nextAction(_ sender: UIButton) {
        self.startLoading(loadingMessage: "Salvando pet...")
        guard let petName = petName else { return }
        let type = typeSegmentedControl.selectedSegmentTitle()
        let gender = typeSegmentedControl.selectedSegmentTitle()
        let breed = breedTextFieldView.text
        let bornDate = Time.current.getDate(from: borndDateTextFieldView.text, format: .fullDate)
        let newPet = Pet(type: type, name: petName, bornDate: bornDate, breed: breed, gender: gender)
        Firebase.shared.registerPetInDatabase(newPet) { (error, completed) in
            if let error = error {
                print("Error saving pet: \(error.localizedDescription)")
                self.stopLoading()
                return
            }
            if completed {
                self.stopLoading()
                self.performSegue(withIdentifier: self.segueIdentifier, sender: self)
            }
        }
    }
}
