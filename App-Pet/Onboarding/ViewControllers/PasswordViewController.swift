//
//  PasswordViewController.swift
//  App-Pet
//
//  Created by Lucas Marques Bighi on 11/10/2019.
//  Copyright © 2019 Lucas Marques Bighi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class PasswordViewController: UIViewController {

    @IBOutlet weak var passwordTextFieldView: TextFieldView!
    @IBOutlet weak var nextButton: UIButton!
    
    private var segueIdentifier = "nameSegue"
    
    var email: String?
    private var password: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextFieldView.delegate = self
    }
    
    @IBAction func nextAction(_ sender: UIButton) {
        let password = passwordTextFieldView.text
        self.password = password
        if let email = email {
            Firebase.shared.createUser(email: email, password: password) { (error) in
                if let error = error {
                    let alert = self.customAlert(message: "Erro ao criar usuário\n\(error.localizedDescription)", type: .error)
                    self.present(alert, animated: true)
                    alert.okButton.addAction {
                        alert.dismiss(animated: true, completion: nil)
                    }
                    return
                }
                self.performSegue(withIdentifier: self.segueIdentifier, sender: self)
            }
        }
    }
}

extension PasswordViewController: TextFieldViewDelegate {
    var components: [String] {
        return [""]
    }
    
    var callerView: UIViewController {
        return self
    }
    
    func changeAction(sender: TextFieldView) {
        if passwordTextFieldView.text.count >= passwordTextFieldView.maxChars {
            nextButton.isEnabled = true
            return
        }
        nextButton.isEnabled = false
    }
    
    
}
