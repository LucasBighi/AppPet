//
//  FloatButton.swift
//  App-Pet
//
//  Created by Lucas Marques Bighi on 06/11/2019.
//  Copyright © 2019 Lucas Marques Bighi. All rights reserved.
//

import Foundation
import UIKit

class FloatButton: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.layer.masksToBounds = false
        self.layer.cornerRadius = self.layer.bounds.size.width / 2
        self.layer.shadowRadius = 1
        self.layer.shadowOpacity = 0.5
    }
}
