//
//  SelectPetTableViewController.swift
//  App-Pet
//
//  Created by Lucas Marques Bighi on 18/10/2019.
//  Copyright © 2019 Lucas Marques Bighi. All rights reserved.
//

import UIKit

class SelectPetTableViewController: UITableViewController {
    
    var pets: [Pet] = []
    private var selectedPets: [Pet] = []
    
    var lastSelectedIndexPath = IndexPath(row: -1, section: 0)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.allowsMultipleSelection = true
        self.tableView.allowsSelectionDuringEditing = true
        if let pets = PUser.shared.pets {
            self.pets = pets
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pets.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = pets[indexPath.row].name
        if cell.isSelected {
            cell.isSelected = false
            if cell.accessoryType == .none {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
        }
        return cell
    }
    
    @IBAction func okAction(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Schedule", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "EditItem") as! EditScheduleViewController
        vc.selectedPets = selectedPets
        self.navigationController?.popViewController(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            if cell.isSelected {
                cell.isSelected = false
                if cell.accessoryType == .none {
                    selectedPets.append(pets[indexPath.row])
                    cell.accessoryType = .checkmark
                } else {
                    selectedPets.remove(at: indexPath.row)
                    cell.accessoryType = .none
                }
            }
        }
    }
}
