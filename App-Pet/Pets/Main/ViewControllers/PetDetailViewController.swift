//
//  PetDetailViewController.swift
//  App-Pet
//
//  Created by Lucas Marques Bighi on 01/10/2019.
//  Copyright © 2019 Lucas Marques Bighi. All rights reserved.
//

import UIKit

class PetDetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var breedLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var schedules = [Schedule]()
    
    var pet: Pet!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupFields()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editPetSegue" {
            let vc = segue.destination as! EditPetViewController
            vc.pet = pet
        }
        if segue.identifier == "imageSegue" {
            let vc = segue.destination as! PetImageViewController
            if let image = imageView.image {
                vc.image = image
            }
        }
    }
    
    func setupFields() {
        if let schedules = PUser.shared.schedules?.forPet(pet) {
            self.schedules = schedules
        }
        imageView.image = UIImage(named: pet.name)
        nameLabel.text = pet.name
        ageLabel.text = String(pet.age)
        breedLabel.text = pet.breed
        genderLabel.text = pet.gender
    }
    
    func setupView() {
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: self.view.bounds.size.width, height: self.view.bounds.size.height))
        let messageLabel = UILabel(frame: rect)
        messageLabel.text = "Nenhum evento para o \(pet.name).\nVocê pode adicionar um novo evento na Agenda."
        messageLabel.textColor = .darkGray
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.sizeToFit()
        tableView.backgroundView = messageLabel
        self.navigationController?.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
    }
}

extension PetDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if schedules.count != 0 {
            tableView.backgroundView?.isHidden = true
        } else {
            tableView.backgroundView?.isHidden = false
        }
        return schedules.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PetScheduleDetailTableViewCell
        cell.schedules = schedules
        cell.setupCell(with: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Schedule", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "EditItem") as! EditScheduleViewController
        vc.schedule = schedules[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Deletar") { (action, sourceView, completionHandler) in
            self.schedules.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            completionHandler(true)
        }
        delete.backgroundColor = .red
        delete.image = UIImage(named: "trash")?.withRenderingMode(.alwaysTemplate)
        let action = UISwipeActionsConfiguration(actions: [delete])
        action.performsFirstActionWithFullSwipe = true
        return action
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let edit = UIContextualAction(style: .normal, title: "Editar") { (action, view, completionHandler) in
            let alert = UIAlertController(title: "Editar tarefa", message: "O que gostaria de fazer?", preferredStyle: .actionSheet)
            let scheduleAction = UIAlertAction(title: "Marcar como agendada", style: .default, handler: { (action) in
                self.schedules[indexPath.row].status = ScheduleStatus.scheduled
                tableView.reloadData()
            })
            let doneAction = UIAlertAction(title: "Marcar como feita", style: .default, handler: { (action) in
                self.schedules[indexPath.row].status = ScheduleStatus.done
                tableView.reloadData()
            })
            let lateAction = UIAlertAction(title: "Marcar como atrasada", style: .default, handler: { (action) in
                self.schedules[indexPath.row].status = ScheduleStatus.late
                tableView.reloadData()
            })
            let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
            alert.addAction(scheduleAction)
            alert.addAction(doneAction)
            alert.addAction(lateAction)
            alert.addAction(cancelAction)
            alert.view.tintColor = .purple
            self.present(alert, animated: true)
            completionHandler(true)
        }
        edit.backgroundColor = UIColor.customYellow
        edit.image = UIImage(named: "edit")
        let action = UISwipeActionsConfiguration(actions: [edit])
        action.performsFirstActionWithFullSwipe = true
        return action
    }
}
