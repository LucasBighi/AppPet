//
//  ChatsTableViewCell.swift
//  App-Pet
//
//  Created by Lucas Marques Bighi on 16/10/2019.
//  Copyright © 2019 Lucas Marques Bighi. All rights reserved.
//

import UIKit

class ChatsTableViewCell: UITableViewCell {

    @IBOutlet weak var chatImageView: UIImageView!
    @IBOutlet weak var chatNameLabel: UILabel!
    @IBOutlet weak var lastMessageTextLabel: UILabel!
    @IBOutlet weak var lastMessageTimeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        chatImageView.layer.cornerRadius = chatImageView.frame.size.width / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
