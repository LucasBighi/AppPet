//
//  GetStartedViewController.swift
//  App-Pet
//
//  Created by Lucas Marques Bighi on 11/10/2019.
//  Copyright © 2019 Lucas Marques Bighi. All rights reserved.
//

import UIKit

class GetStartedViewController: UIViewController {

    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFields()
    }
    
    private func setupFields() {
        guard let user = Firebase.shared.user else { return }
        welcomeLabel.text = "Bem vindo, \(user.displayName ?? "")"
        Firebase.shared.downloadImage(folder: "users-profile-images", imageName: user.uid, success: { (image) in
            self.userImage.image = image
        }) { (error) in
            print("Error downloading image\n\(error.localizedDescription)")
        }
        userImage.layer.cornerRadius = userImage.bounds.size.width / 2
    }
}
