//
//  EditScheduleViewController.swift
//  App-Pet
//
//  Created by Lucas Marques Bighi on 01/10/2019.
//  Copyright © 2019 Lucas Marques Bighi. All rights reserved.
//

import UIKit
import UserNotifications

class EditScheduleViewController: UIViewController {

    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var textFieldViewPet: TextFieldView!
    @IBOutlet weak var textFieldViewType: TextFieldView!
    @IBOutlet weak var switchAllDays: UISwitch!
    @IBOutlet weak var textFieldViewDescription: TextFieldView!
    @IBOutlet weak var petsModalHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var petsModalBottomConstraint: NSLayoutConstraint!
    
    var modalView = ModalViewController(nibName: "ModalViewController", bundle: nil)
    var activeTextField: TextFieldView!
    let datePicker = UIDatePicker()
    var schedule: Schedule?
    var date: Date?
    var pets = [Pet]()
    var selectedPets = [Pet]()
    let notifications = Notifications()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDatePicker()
        setupView()
        if let schedule = schedule {
            setupFields(with: schedule)
        } else {
            self.title = "Nova tarefa"
            let now = Date()
            dateTextField.text = Time.current.formatDate(date: now, format: .fullDateTime)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.view.endEditing(true)
        self.textFieldViewPet.lostFocus(true)
    }
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    func setupView() {
        textFieldViewPet.delegate = self
        textFieldViewType.delegate = self
        textFieldViewType.componentsArray = ScheduleType.allCases.map {$0.rawValue}
        if let pets = PUser.shared.pets {
            self.pets = pets
        }
        if let pets = schedule?.pets {
            selectedPets = pets
        }
    }
    
    func setupFields(with schedule: Schedule) {
        self.title = "Editar tarefa"
        dateTextField.text = Time.current.formatDate(date: schedule.date, format: .fullDateTime)
        textFieldViewPet.text = schedule.pets.separated()
        textFieldViewType.text = schedule.type.rawValue
        switchAllDays.isOn = schedule.allDays
        textFieldViewDescription.text = schedule.description
    }
    
    func setupDatePicker() {
        datePicker.datePickerMode = .dateAndTime
        datePicker.locale = Time.current.locale
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "OK", style: .plain, target: self, action: #selector(done))
        doneButton.tintColor = .purple
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancelar", style: .plain, target: self, action: #selector(cancel))
        cancelButton.tintColor = .purple
        toolbar.setItems([cancelButton, space, doneButton], animated: false)
        dateTextField.inputAccessoryView = toolbar
        dateTextField.inputView = datePicker
    }
    
    func showPetsModalView(_ show: Bool) {
        UIView.animate(withDuration: 0.2) {
            if show {
                self.petsModalBottomConstraint.constant = 0
            } else {
                self.petsModalBottomConstraint.constant = -(self.petsModalHeightConstraint.constant + 14)
            }
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func petsModalOkAction(_ sender: UIButton) {
        textFieldViewPet.text = selectedPets.separated()
        showPetsModalView(false)
    }
    
    @IBAction func petsModalCancelAction(_ sender: UIButton) {
        showPetsModalView(false)
    }
    
    @IBAction func saveAction(_ sender: UIBarButtonItem) {
        let date = datePicker.date
        let type = ScheduleType(value: textFieldViewType.text)
        let allDays = switchAllDays.isOn
        let description = textFieldViewDescription.text
        let newSchedule = Schedule(pets: selectedPets, date: date, type: type, allDays: allDays, description: description)
        PUser.shared.schedules?.append(newSchedule)
        notifications.scheduleNotification(schedule: newSchedule)
        let alert = customAlert(message: "Tarefa salva com sucesso!", type: .success)
        self.present(alert, animated: true)
        alert.okButton.addAction {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    @objc func done() {
        let date = datePicker.date
        self.date = date
        dateTextField.text = Time.current.formatDate(date: date, format: .fullDateTime)
        dismissDatePicker()
    }
    
    @objc func cancel() {
        dismissDatePicker()
    }
    
    func dismissDatePicker() {
        self.view.endEditing(true)
    }
}

extension EditScheduleViewController: TextFieldViewDelegate {
    var components: [String] {
        return [""]
    }
    
    var callerView: UIViewController {
        return self
    }
    
    func changeAction(sender: TextFieldView) {
//        if sender.identifier == "pet" {
//            showPetsModalView(true)
//        }
//        else {
            modalView.modalPresentationStyle = .overCurrentContext
            activeTextField = sender
            self.present(modalView, animated: true)
        //}
    }
}

extension EditScheduleViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = pets[indexPath.row].name
        cell.backgroundColor = #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.9568627451, alpha: 1)
        if selectedPets.contains(pets[indexPath.row]) {
            cell.isSelected = true
            cell.accessoryType = .checkmark
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            if cell.isSelected {
                cell.isSelected = false
            }
            if selectedPets.contains(pets[indexPath.row]) {
                if let index = selectedPets.index(comparing: pets[indexPath.row]) {
                    selectedPets.remove(at: index)
                }
                cell.accessoryType = .none
            } else {
                selectedPets.append(pets[indexPath.row])
                cell.accessoryType = .checkmark
            }
            textFieldViewPet.text = selectedPets.separated()
        }
    }
}
