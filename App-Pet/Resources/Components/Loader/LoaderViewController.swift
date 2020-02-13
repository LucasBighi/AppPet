//
//  LoaderViewController.swift
//  App-Pet
//
//  Created by Lucas Marques Bighi on 17/10/2019.
//  Copyright © 2019 Lucas Marques Bighi. All rights reserved.
//

import UIKit

class LoaderViewController: UIViewController {
    
    @IBOutlet weak var labelMessage: UILabel!
    @IBOutlet weak var suspensionPointsLabel: UILabel!
    @IBOutlet var paws: [UIImageView]!
    
    var index = 0
    var points = "."
    
    func animatePaw() {
        UIView.animate(withDuration: 0.5, delay: 0, options: [.autoreverse], animations: {
            self.paws[self.index].alpha = 1
            self.suspensionPointsLabel.text = self.points
        }) { (completed) in
            self.paws[self.index].alpha = 0
            if self.index < 3 {
                self.index = self.index + 1
            } else {
                self.index = 0
            }
            self.animatePaw()
        }
        self.view.layoutIfNeeded()
    }
    
    func animateSuspensionPoints() {
        UIView.transition(with: suspensionPointsLabel, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.suspensionPointsLabel.text = self.points
        }) { (_) in
            if self.points == "..." {
                self.points = ""
            } else {
                self.points = "\(self.points)."
            }
            self.animateSuspensionPoints()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animatePaw()
        animateSuspensionPoints()
    }
}
