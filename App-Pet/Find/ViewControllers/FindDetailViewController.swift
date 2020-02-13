//
//  FindDetailViewController.swift
//  App-Pet
//
//  Created by Lucas Marques Bighi on 07/10/2019.
//  Copyright © 2019 Lucas Marques Bighi. All rights reserved.
//

import UIKit

class FindDetailViewController: UIViewController {

    @IBOutlet weak var petImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var localLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var isFavorite = false
    var petName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideNavigationBar(true)
        navigationItem.title = petName
        petImageView.image = UIImage(named: petName)
        nameLabel.text = petName
    }
    @IBAction func favoriteAction(_ sender: UIBarButtonItem) {
        if isFavorite {
            sender.image = UIImage(named: "heart")
        } else {
            sender.image = UIImage(named: "heart-filled")
        }
        isFavorite = !isFavorite
    }
}
