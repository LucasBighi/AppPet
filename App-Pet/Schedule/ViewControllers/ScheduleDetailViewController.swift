//
//  ScheduleDetailViewController.swift
//  App-Pet
//
//  Created by Lucas Marques Bighi on 08/10/2019.
//  Copyright © 2019 Lucas Marques Bighi. All rights reserved.
//

import UIKit

class ScheduleDetailViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var components = DateComponents()
    var schedules = [Schedule]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        guard let date = Calendar.current.date(from: components) else { return }
        self.navigationItem.title = Time.current.formatDate(date: date, format: .fullDate)
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: self.view.bounds.size.width, height: self.view.bounds.size.height))
        let messageLabel = UILabel(frame: rect)
        messageLabel.text = "Nenhum evento nesse dia\nAdicione um evento clicando no + acima"
        messageLabel.textColor = .darkGray
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.sizeToFit()
        tableView.backgroundView = messageLabel
        tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.tabBarController?.tabBar.isHidden = true
        tableView.reloadData()
    }
}

extension ScheduleDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if schedules.count != 0 {
            tableView.backgroundView?.isHidden = true
        } else {
            tableView.backgroundView?.isHidden = false
        }
        return schedules.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ScheduleDetailTableViewCell
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
            self.tableView.deleteRows(at: [indexPath], with: .fade)
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
                self.tableView.reloadData()
            })
            let doneAction = UIAlertAction(title: "Marcar como feita", style: .default, handler: { (action) in
                self.schedules[indexPath.row].status = ScheduleStatus.done
                self.tableView.reloadData()
            })
            let lateAction = UIAlertAction(title: "Marcar como atrasada", style: .default, handler: { (action) in
                self.schedules[indexPath.row].status = ScheduleStatus.late
                self.tableView.reloadData()
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
