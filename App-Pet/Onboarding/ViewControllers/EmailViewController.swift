//
//  EmailViewController.swift
//  App-Pet
//
//  Created by Lucas Marques Bighi on 11/10/2019.
//  Copyright © 2019 Lucas Marques Bighi. All rights reserved.
//

import UIKit
import FirebaseAuth

class EmailViewController: UIViewController {
    
    @IBOutlet weak var emailTextFieldView: TextFieldView!
    @IBOutlet weak var nextButton: UIButton!
    
    var email: String?
    let segueIdentifier = "passwordSegue"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextFieldView.delegate = self
    }
    
    @IBAction func nextAction(_ sender: UIButton) {
        let email = emailTextFieldView.text
        self.email = email
        self.performSegue(withIdentifier: self.segueIdentifier, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueIdentifier {
            let vc = segue.destination as! PasswordViewController
            vc.email = email
        }
    }
}

extension EmailViewController: TextFieldViewDelegate {
    var components: [String] {
        return [""]
    }
    
    var callerView: UIViewController {
        return self
    }
    
    func changeAction(sender: TextFieldView) {
        emailTextFieldView.errorMessage = ""
        if emailTextFieldView.text.isEmailValid() {
            nextButton.isEnabled = true
            return
        }
        nextButton.isEnabled = false
    }
}
