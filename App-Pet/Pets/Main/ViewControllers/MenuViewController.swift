//
//  MenuViewController.swift
//  App-Pet
//
//  Created by Lucas Marques Bighi on 11/10/2019.
//  Copyright © 2019 Lucas Marques Bighi. All rights reserved.
//

import UIKit
import FirebaseUI

class MenuViewController: UIViewController {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var contentLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var contentWidthConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        //width = view.bounds.width - 80
        userImageView.layer.cornerRadius = userImageView.layer.bounds.size.width / 2
        contentLeadingConstraint.constant = -contentWidthConstraint.constant
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.5, animations: {
            self.contentLeadingConstraint.constant = -self.contentWidthConstraint.constant
            self.view.layoutIfNeeded()
        }) { (completed) in
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.5) {
            //self.contentWidthConstraint.constant = self.width
            self.contentLeadingConstraint.constant = 0
            self.backgroundView.alpha = 0.3
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func logout(_ sender: UIButton) {
        let alert = UIAlertController(title: nil, message: "Deseja realmente sair?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            self.performSegue(withIdentifier: "Logout", sender: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
}
