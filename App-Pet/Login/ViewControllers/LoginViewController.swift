//
//  LoginViewController.swift
//  App-Pet
//
//  Created by Lucas Marques Bighi on 10/10/2019.
//  Copyright © 2019 Lucas Marques Bighi. All rights reserved.
//

import UIKit
import FirebaseStorage

class LoginViewController: UIViewController {

    @IBOutlet weak var leftSeparatorView: UIView!
    @IBOutlet weak var rightSeparatorView: UIView!
    @IBOutlet weak var emailTextFieldView: TextFieldView!
    @IBOutlet weak var passwordTextFieldView: TextFieldView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        emailTextFieldView.delegate = self
        passwordTextFieldView.delegate = self
        leftSeparatorView.layer.borderColor = UIColor.customLightGray.cgColor
        leftSeparatorView.layer.borderWidth = 0.4
        rightSeparatorView.layer.borderColor = UIColor.customLightGray.cgColor
        rightSeparatorView.layer.borderWidth = 0.4
        facebookButton.layer.cornerRadius = 6
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    @IBAction func loginAction(_ sender: UIButton) {
        let email = emailTextFieldView.text
        let password = passwordTextFieldView.text
        Firebase.shared.login(email: email, password: password) { (error) in
            if let error = error {
                let alert = self.customAlert(message: "Erro ao fazer login\n\(error.localizedDescription)", type: .error)
                self.present(alert, animated: true)
                alert.okButton.addAction {
                    alert.dismiss(animated: true, completion: nil)
                }
                return
            }
            self.performSegue(withIdentifier: "homeSegue", sender: self)
        }
    }
    
    @IBAction func forgotPasswordAction(_ sender: UIButton) {
        let sb = UIStoryboard(name: "Login", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "ForgotPassword") as! ForgotPasswordViewController
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension LoginViewController: TextFieldViewDelegate {
    
    var callerView: UIViewController {
        return self
    }
    
    func changeAction(sender: TextFieldView) {
        if emailTextFieldView.text.isEmailValid(), passwordTextFieldView.text.count >= passwordTextFieldView.maxChars {
            loginButton.isEnabled = true
            return
        }
        loginButton.isEnabled = false
    }
}
