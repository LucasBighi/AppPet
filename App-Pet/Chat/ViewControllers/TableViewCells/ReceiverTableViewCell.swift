//
//  ReceiverTableViewCell.swift
//  App-Pet
//
//  Created by Lucas Marques Bighi on 16/10/2019.
//  Copyright © 2019 Lucas Marques Bighi. All rights reserved.
//

import UIKit

class ReceiverTableViewCell: UITableViewCell {

    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var pointView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        pointView.transform = CGAffineTransform(rotationAngle: 40)
        pointView.layer.cornerRadius = 6
        messageView.layer.cornerRadius = 6
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
