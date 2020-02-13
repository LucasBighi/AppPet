//
//  EditPetViewController.swift
//  App-Pet
//
//  Created by Lucas Marques Bighi on 03/10/2019.
//  Copyright © 2019 Lucas Marques Bighi. All rights reserved.
//

import UIKit

class EditPetViewController: UIViewController {

    @IBOutlet weak var savePetActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var typeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var genderSegmentedControl: UISegmentedControl!
    
    let datePicker = UIDatePicker()
    var isPetEditing = false
    var pet: Pet?
    var smallImage: UIImage?
    var bornDate: Date!
    var modalView = ModalViewController(nibName: "ModalViewController", bundle: nil)
    var activeTextField: TextFieldView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupDatePicker()
        if let pet = pet {
            setupFields(with: pet)
        }
    }
    
    func setupView() {
        self.navigationController?.tabBarController?.tabBar.isHidden = true
        modalView.delegate = self
        if let breeds = loadJson(fileName: "Breeds") {
            //breedTextFieldView.componentsArray = breeds
        }
    }
    
    func setupDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.locale = Time.current.locale
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "OK", style: .plain, target: self, action: #selector(done))
        doneButton.tintColor = .purple
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancelar", style: .plain, target: self, action: #selector(cancel))
        cancelButton.tintColor = .purple
        toolbar.setItems([cancelButton, space, doneButton], animated: false)
    }
    
    func setupFields(with pet: Pet) {
//        editImageButton.setTitle("Editar imagem...", for: .normal)
//        imageView.image = UIImage(named: pet.name)
        typeSegmentedControl.selectSegment(with: pet.type)
        genderSegmentedControl.selectSegment(with: pet.gender)
        //typeTextFieldView.text = pet.type.rawValue
//        nameTextFieldView.text = pet.name
//        ageTextFieldView.text = Time.current.formatDate(date: pet.bornDate, format: .fullDate)
//        breedTextFieldView.text = pet.breed
        //genderTextFieldView.text = pet.gender.rawValue
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.resignFirstResponder()
    }
    
    @objc func done() {
        bornDate = datePicker.date
        //ageTextFieldView.text = Time.current.formatDate(date: bornDate, format: .fullDate)
        dismissDatePicker()
    }
    
    @objc func cancel() {
        dismissDatePicker()
    }
    
    func dismissDatePicker() {
        self.view.endEditing(true)
    }
    
//    @IBAction func save(_ sender: UIBarButtonItem) {
//        savePetActivityIndicator.startAnimating()
//        //guard let image = imageView.image else { return }
//        let type = typeSegmentedControl.selectedSegmentTitle()
//        let gender = genderSegmentedControl.selectedSegmentTitle()
//        //let name = nameTextFieldView.text
//        let bornDate = Time.current.getDate(from: ageTextFieldView.text, format: .fullDate)
//        //let breed = breedTextFieldView.text
//        let newPet = Pet(image: image, type: type, name: name, bornDate: bornDate, breed: breed, gender: gender)
//        self.pet = newPet
//        Firebase.shared.registerPetInDatabase(newPet) { (error, completed)  in
//            var message = ""
//            var type: AlertType = .success
//            if let error = error {
//                message = "Erro ao salvar o Pet :/"
//                type = .error
//                print("Error saving pet: \(error.localizedDescription)")
//                return
//            }
//            if completed {
//                message = "Pet \(name) salvo com sucesso!"
//                type = .success
//                self.savePetActivityIndicator.stopAnimating()
//                let alert = self.customAlert(message: message, type: type)
//                self.present(alert, animated: true)
//                alert.okButton.addAction {
//                    self.navigationController?.popViewController(animated: true)
//                }
//            }
//        }
//    }
    
//    @IBAction func editImage(_ sender: UIButton) {
//        if imageView.image != UIImage(named: "camera-large-gray") {
//            let alert = UIAlertController(title: "Editar imagem", message: "O que gostaria de fazer?", preferredStyle: .actionSheet)
//            let newImageAction = UIAlertAction(title: "Selecionar imagem...", style: .default) { (action) in
//                self.selectImage()
//            }
//            let deleteAction = UIAlertAction(title: "Excluir imagem", style: .destructive) { (action) in
//                self.imageView.image = UIImage(named: "camera-large-gray")
//            }
//            let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
//            alert.addAction(newImageAction)
//            alert.addAction(deleteAction)
//            alert.addAction(cancelAction)
//            alert.view.tintColor = .purple
//            self.present(alert, animated: true)
//        } else {
//            selectImage()
//        }
//    }
    
    func selectImage() {
        let alert = UIAlertController(title: "Selecionar imagem", message: "De onde você quer escolher a imagem do Pet?", preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Câmera", style: .default) { [weak self] (_) in
                guard let self = self else {return}
                self.selectPicture(sourceType: .camera)
            }
            alert.addAction(cameraAction)
        }
        
        let libraryAction = UIAlertAction(title: "Biblioteca de Fotos", style: .default) { [weak self] (_) in
            guard let self = self else {return}
            self.selectPicture(sourceType: .photoLibrary)
        }
        alert.addAction(libraryAction)
        
        let photosAction = UIAlertAction(title: "Álbum de Fotos", style: .default) { [weak self] (_) in
            guard let self = self else {return}
            self.selectPicture()
        }
        alert.addAction(photosAction)
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        alert.view.tintColor = .purple
        present(alert, animated: true, completion: nil)
    }
    
    func alert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { [weak self] (_) in
            guard let self = self else {return}
            self.navigationController?.popToRootViewController(animated: true)
        }
        alert.view.tintColor = .purple
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    func selectPicture(sourceType: UIImagePickerController.SourceType = .savedPhotosAlbum) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
}

//extension EditPetViewController: TextFieldViewDelegate {
//    var callerView: UIViewController {
//        return self
//    }
//
//    func changeAction(sender: TextFieldView) {
//        modalView.modalPresentationStyle = .overCurrentContext
//        activeTextField = sender
//        self.present(modalView, animated: true)
//    }
//}

extension EditPetViewController: ModalViewControllerDelegate {
    var componentsOfModal: [String] {
        get {
            return activeTextField.componentsArray
                ?? [""]     }
    }
    
    var activeView: UIView {
        return self.view
    }
    
    var sender: TextFieldView {
        return activeTextField
    }
    
    func didSelectComponent() {
        activeTextField.text = modalView.selectedComponent!
    }
}

extension EditPetViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage {
            let proportion: CGFloat = image.size.width / image.size.height
            let imageWidth: CGFloat = 800.00
            let size = CGSize(width: imageWidth, height: imageWidth / proportion)
            UIGraphicsBeginImageContext(size)
            image.draw(in: CGRect(origin: .zero, size: size))
            smallImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
//            imageView.image = smallImage
//            editImageButton.setTitle("Editar imagem...", for: .normal)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
