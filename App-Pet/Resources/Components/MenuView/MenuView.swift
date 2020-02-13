//
//  MenuView.swift
//  App-Pet
//
//  Created by Lucas Marques Bighi on 24/10/2019.
//  Copyright © 2019 Lucas Marques Bighi. All rights reserved.
//

import UIKit
import FirebaseStorage

class MenuView: UIView {
    
    @IBOutlet weak var labelUsername: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var editProfileButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    
    class func instanceFromNib() -> MenuView {
        return UINib(nibName: "MenuView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! MenuView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
        setupFields()
    }
    
    func setupView() {
        imageView.layer.cornerRadius = imageView.bounds.size.width / 2
    }
    
    func setupFields() {
        let ref = Storage.storage().reference(withPath: "pets-profile-images/yEc81PGW4srgUBqj8f75.jpeg")
        imageView.sd_setImage(with: ref)
        if let user = Firebase.shared.user {
//            Firebase.shared.downloadImage(folder: "users-profile-images", imageName: user.uid, success: { (image) in
//                self.imageView.image = image
//            }) { (error) in
//                print("Error downloading image\n\(error.localizedDescription)")
//            }
        }
        imageView.sd_setImage(with: ref)
    }
    
    @IBAction func editProfileAction(_ sender: UIButton) {
        
    }
    
    @IBAction func logoutAction(_ sender: UIButton) {
        
    }
}
