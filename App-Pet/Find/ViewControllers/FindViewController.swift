//
//  FindViewController.swift
//  App-Pet
//
//  Created by Lucas Marques Bighi on 04/10/2019.
//  Copyright © 2019 Lucas Marques Bighi. All rights reserved.
//

import UIKit

class FindViewController: UIViewController {
    
    @IBOutlet weak var filterViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var lostPetButton: UIButton!
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var rangeSlider: UISlider!
    @IBOutlet weak var filterViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var rangeTextField: UITextField!
    
    let pets = ["Bob", "Beethoven"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func filtersAction(_ sender: UIBarButtonItem) {
        UIView.animate(withDuration: 0.2) {
            self.filterView.alpha = 1
            self.backgroundView.alpha = 0.3
            self.filterViewTopConstraint.constant = 0
            self.tabBarController?.tabBar.isHidden = true
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func filterAction(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2) {
            self.filterView.alpha = 0
            self.backgroundView.alpha = 0
            self.tabBarController?.tabBar.isHidden = false
            self.filterViewTopConstraint.constant = -self.filterViewTopConstraint.constant
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func rangeSliderValueChanged(_ sender: UISlider) {
        rangeTextField.text = String(rangeSlider.value.rounded())
    }
    
    @IBAction func rangeTextFieldValueChanged(_ sender: UITextField) {
        if let value = Int(rangeTextField.text!) {
            rangeSlider.value = Float(value).rounded()
        }
    }
}

extension FindViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FindTableViewCell
        cell.petImageView.image = UIImage(named: pets[row])
        cell.nameLabel.text = pets[row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        let sb = UIStoryboard(name: "Find", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "FindDetail") as! FindDetailViewController
        vc.petName = pets[row]
        navigationController?.pushViewController(vc, animated: true)
    }
}
