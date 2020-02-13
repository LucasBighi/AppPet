//
//  SeparatorView.swift
//  App-Pet
//
//  Created by Lucas Marques Bighi on 05/11/2019.
//  Copyright © 2019 Lucas Marques Bighi. All rights reserved.
//

import Foundation
import UIKit

class SeparatorView: UIView, NibLoadable {
    @IBOutlet weak var separatorLine: UIView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    private func setup() {
        self.setupFromNib()
        separatorLine.layer.borderColor = UIColor.lightGray.cgColor
        separatorLine.layer.borderWidth = 0.3
    }
    
}
