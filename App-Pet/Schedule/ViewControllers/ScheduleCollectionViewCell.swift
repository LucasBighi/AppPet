//
//  ScheduleCollectionViewCell.swift
//  App-Pet
//
//  Created by Lucas Marques Bighi on 26/09/2019.
//  Copyright © 2019 Lucas Marques Bighi. All rights reserved.
//

import UIKit

class ScheduleCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var counterView: UIView!
    @IBOutlet weak var counterLabel: UILabel!
    
    func isToday(comparing indexDay: Int, with passedDate: Date) -> Bool {
        let currentDate = Date()
        
        if indexDay == currentDate.get(.day),
        passedDate.get(.month) == currentDate.get(.month),
            passedDate.get(.year) == currentDate.get(.year) {
            return true
        }
        return false
    }
    
    func setupCell(date: Date, for schedules: [Schedule], with indexPath: IndexPath) {
        let contentLayer = self.contentView.layer
        let cellLayer = self.layer
        contentLayer.cornerRadius = 10
        contentLayer.borderWidth = 1.0
        contentLayer.borderColor = UIColor.clear.cgColor
        contentLayer.masksToBounds = true
        cellLayer.cornerRadius = 10
        cellLayer.shadowColor = UIColor.gray.cgColor
        cellLayer.shadowOffset = CGSize(width: 0, height: 3)
        cellLayer.shadowRadius = 2
        cellLayer.shadowOpacity = 1
        cellLayer.masksToBounds = false
        cellLayer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: contentLayer.cornerRadius).cgPath
        
        let daysArray = date.allMonthDays()
        let day = daysArray[indexPath.row]
        dayLabel.text = String(day)
        setSchedulesCount(schedules.forDay(day, inDate: date).count)
        if day == 0 {
            self.alpha = 0
            return
        }
        if isToday(comparing: day, with: date) {
            self.contentView.backgroundColor = .purple
            dayLabel.font = UIFont.boldSystemFont(ofSize: 17)
            dayLabel.textColor = .white
        } else {
            dayLabel.font = UIFont.boldSystemFont(ofSize: 17)
            self.contentView.backgroundColor = .white
            dayLabel.textColor = .darkGray
        }
    }
    
    func setSchedulesCount(_ numberOfSchedules: Int) {
        if numberOfSchedules != 0 {
            counterView.isHidden = false
            counterView.backgroundColor = .lightGray
            counterView.layer.cornerRadius = counterView.frame.size.width / 2
            counterLabel.text = String(numberOfSchedules)
        } else {
            counterView.isHidden = true
        }
    }
}
