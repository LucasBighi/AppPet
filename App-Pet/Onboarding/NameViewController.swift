//
//  NameViewController.swift
//  App-Pet
//
//  Created by Lucas Marques Bighi on 11/10/2019.
//  Copyright © 2019 Lucas Marques Bighi. All rights reserved.
//

import UIKit

class NameViewController: UIViewController {

    @IBOutlet weak var nameTextFieldView: TextFieldView!
    @IBOutlet weak var nextButton: UIButton!
    
    private var name: String?
    var segueIdentifier = "imageSegue"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextFieldView.delegate = self
    }
    
    @IBAction func nextAction(_ sender: UIButton) {
        let name = nameTextFieldView.text
        self.name = name
        guard let user = Firebase.shared.user else { return }
        Firebase.shared.changeNameRequest(user: user, name: name) { (error) in
            if let error = error {
                let alert = self.customAlert(message: "Erro ao salvar o nome\n\(error.localizedDescription)", type: .error)
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

extension NameViewController: TextFieldViewDelegate {
    var components: [String] {
        return [""]
    }
    
    var callerView: UIViewController {
        return self
    }
    
    func changeAction(sender: TextFieldView) {
        if nameTextFieldView.text.isNameValid() {
            nextButton.isEnabled = true
            return
        }
        nextButton.isEnabled = false
    }
}
