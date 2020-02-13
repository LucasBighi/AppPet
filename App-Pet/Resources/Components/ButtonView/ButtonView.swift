//
//  TextFieldView.swift
//  App-Pet
//
//  Created by Lucas Marques Bighi on 26/08/2019.
//  Copyright © 2019 Lucas Marques Bighi. All rights reserved.
//

import UIKit

@IBDesignable
class ButtonView: UIView, NibLoadable {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var mainButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var notificationView: UIView!
    @IBOutlet weak var notificationLabel: UILabel!
    
    var notificationCount: String = ""
    
    @IBInspectable var title: String = "" {
        didSet {
            titleLabel.text = title
        }
    }
    
    @IBInspectable var icon: String = "" {
        didSet {
            mainButton.setImage(UIImage(named: icon), for: .normal)
        }
    }
    
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
        let bgLayer = backgroundView.layer
        notificationView.layer.cornerRadius = notificationView.frame.width / 2
        bgLayer.borderColor = UIColor.purple.cgColor
        bgLayer.borderWidth = 1
        bgLayer.cornerRadius = 5
        if notificationCount == "" {
            notificationView.isHidden = true
        } else {
            notificationView.isHidden = false
            notificationLabel.text = notificationCount
        }
    }
}
