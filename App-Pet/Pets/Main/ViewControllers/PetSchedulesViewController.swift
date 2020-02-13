//
//  PetSchedulesViewController.swift
//  App-Pet
//
//  Created by Lucas Marques Bighi on 10/10/2019.
//  Copyright © 2019 Lucas Marques Bighi. All rights reserved.
//

import UIKit

class PetSchedulesViewController: UIViewController {
    
    var scheduleName = ""
    var petName = ""
    var scheduleIndex = 0

    @IBOutlet weak var schedulesSegmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        schedulesSegmentedControl.selectedSegmentIndex = scheduleIndex
        navigationItem.title = "\(scheduleName) do \(petName)"
    }
    
    @IBAction func scheduleChanged(_ sender: UISegmentedControl) {
        if let title = sender.titleForSegment(at: sender.selectedSegmentIndex) {
            navigationItem.title = "\(title) do \(petName)"
        }
    }
}

extension PetSchedulesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = String(indexPath.row)
        cell.detailTextLabel?.text = String(indexPath.row)
        return cell
    }
    
    
}
