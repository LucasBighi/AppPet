//
//  ScheduleViewController.swift
//  App-Pet
//
//  Created by Lucas Marques Bighi on 26/09/2019.
//  Copyright © 2019 Lucas Marques Bighi. All rights reserved.
//

import UIKit

class ScheduleViewController: UIViewController {
    
    var daysArray: [Int] = []
    var date = Date()
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var monthNameLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    
    var schedules = [Schedule]()
    
    var width: CGFloat {
        return (view.frame.size.width-80)/7
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let schedule1 = Schedule(pets: PUser.shared.pets!, date: date, type: ScheduleType.pet, allDays: false, description: "Banho no Petz")
        let schedule2 = Schedule(pets: [PUser.shared.pets![0]], date: date, type: ScheduleType.remedio, allDays: true, description: "Da Otite")
        PUser.shared.schedules = [schedule1, schedule2]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.tabBarController?.tabBar.isHidden = false
        if let schedules = PUser.shared.schedules {
            self.schedules = schedules
        }
        setupView(with: date)
    }
    
    func setupView(with date: Date) {
        self.date = date
        daysArray = date.allMonthDays()
        monthNameLabel.text = date.monthName()
        yearLabel.text = String(date.year())
        collectionView.reloadData()
    }
    
    @IBAction func goToTodayAction(_ sender: UIBarButtonItem) {
        setupView(with: Date())
    }
    
    @IBAction func increaseAction(_ sender: UIButton) {
        setupView(with: date.stepMonth(step: 1))
    }
    
    @IBAction func decreaseAction(_ sender: UIButton) {
        setupView(with: date.stepMonth(step: -1))
    }
}

extension ScheduleViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return date.allMonthDays().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ScheduleCollectionViewCell
        cell.setupCell(date: date, for: schedules, with: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Schedule", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ScheduleDetail") as! ScheduleDetailViewController
        let day = daysArray[indexPath.row]
        vc.schedules = schedules.forDay(day, inDate: date)
        vc.components = DateComponents(year: date.get(.year), month: date.get(.month), day: day)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: width, height: width)
    }
}
