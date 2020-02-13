//
//  ImageViewController.swift
//  App-Pet
//
//  Created by Lucas Marques Bighi on 11/10/2019.
//  Copyright © 2019 Lucas Marques Bighi. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {
    
    private var segueIdentifier = "getStartedSegue"
    
    //var petOwner: PetOwner?
    
    private var smallImage: UIImage?
    //var auth = Auth.auth()
    //var db = Firestore.firestore()
    //var usersRef: CollectionReference?
    //var user: User?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func selectImageAction(_ sender: UIButton) {
        selectImage()
    }
    
    func selectImage() {
        let alert = UIAlertController(title: "Selecionar foto", message: "De onde você quer escolher sua foto?", preferredStyle: .actionSheet)
        
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
    
    func selectPicture(sourceType: UIImagePickerController.SourceType = .savedPhotosAlbum) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
//    func registerOwnerInDatabase(_ petOwner: PetOwner) {
//        usersRef?.addDocument(data: petOwner.representation, completion: { (error) in
//            if let error = error {
//                print("Error: \(error.localizedDescription)")
//                return
//            }
//        })
//    }
}

extension ImageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage {
            let proportion: CGFloat = image.size.width / image.size.height
            let imageWidth: CGFloat = 800.00
            let size = CGSize(width: imageWidth, height: imageWidth / proportion)
            UIGraphicsBeginImageContext(size)
            image.draw(in: CGRect(origin: .zero, size: size))
            smallImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        }
        dismiss(animated: true) {
            if let image = self.smallImage {
                Firebase.shared.uploadUserImage(image: image) { (url) in
                    if let url = url {
                        guard let name = Firebase.shared.user?.displayName else { return }
                        let petUser = PetUser(name: name, imgUrl: url)
                        Firebase.shared.registerUserInDatabase(petUser, completion: { (error) in
                            if let error = error {
                                let alert = self.customAlert(message: "Erro ao salvar\n\(error.localizedDescription)", type: .error)
                                self.present(alert, animated: true)
                                return
                            }
                        })
                        self.performSegue(withIdentifier: self.segueIdentifier, sender: self)
                    }
                }
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
