//
//  PetScheduleDetailTableViewCell.swift
//  App-Pet
//
//  Created by Lucas Marques Bighi on 08/10/2019.
//  Copyright © 2019 Lucas Marques Bighi. All rights reserved.
//

import UIKit

class PetScheduleDetailTableViewCell: UITableViewCell {
    @IBOutlet weak var scheduleImageButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var statusButton: UIButton!
    
    var schedules = [Schedule]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func setupCell(with indexPath: IndexPath){
        let iconName = "\(schedules[indexPath.row].type.rawValue)-icon"
        let date = Time.current.formatDate(date: schedules[indexPath.row].date, format: .time)
        scheduleImageButton.setImage(UIImage(named: iconName), for: .normal)
        descriptionLabel.text = schedules[indexPath.row].description
        timeLabel.text = date
        if let status = schedules[indexPath.row].status {
            switch status {
            case .scheduled:
                statusButton.setImage(UIImage(named: "scheduled"), for: .normal)
                statusButton.tintColor = UIColor.purple
            case .done:
                statusButton.setImage(UIImage(named: "done"), for: .normal)
                statusButton.tintColor = UIColor.customGreen
            case .late:
                statusButton.setImage(UIImage(named: "late"), for: .normal)
                statusButton.tintColor = UIColor.customRed
            case .none:
                statusButton.setImage(UIImage(named: "none"), for: .normal)
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
