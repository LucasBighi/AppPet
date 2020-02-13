//
//  RoundedButton.swift
//  App-Pet
//
//  Created by Lucas Marques Bighi on 05/11/2019.
//  Copyright © 2019 Lucas Marques Bighi. All rights reserved.
//

import Foundation
import UIKit

class RoundedButton: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = self.layer.bounds.size.width / 2
    }
}
