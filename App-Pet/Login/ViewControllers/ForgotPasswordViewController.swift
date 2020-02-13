//
//  ForgotPasswordViewController.swift
//  App-Pet
//
//  Created by Lucas Marques Bighi on 24/10/2019.
//  Copyright © 2019 Lucas Marques Bighi. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController {

    @IBOutlet weak var emailTextFieldView: TextFieldView!
    @IBOutlet weak var sendEmailButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextFieldView.delegate = self
        setupView()
    }
    
    func setupView() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.backItem?.title = " "
    }
    
    @IBAction func sendEmailAction(_ sender: UIButton) {
        let alert = customAlert(message: "E-mail enviado", type: .success)
        self.present(alert, animated: true)
        alert.okButton.addAction {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension ForgotPasswordViewController: TextFieldViewDelegate {
    
    var callerView: UIViewController {
        return self
    }
    
    func changeAction(sender: TextFieldView) {
        if emailTextFieldView.text.isEmailValid() {
            sendEmailButton.isEnabled = true
            return
        }
        sendEmailButton.isEnabled = false
    }
}
