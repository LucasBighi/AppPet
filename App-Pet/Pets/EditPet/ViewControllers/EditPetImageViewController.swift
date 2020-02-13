//
//  EditPetImageViewController.swift
//  App-Pet
//
//  Created by Lucas Marques Bighi on 05/11/2019.
//  Copyright © 2019 Lucas Marques Bighi. All rights reserved.
//

import UIKit

class EditPetImageViewController: UIViewController {
    
    private var smallImage: UIImage?

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var editImageButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        headerView.layer.cornerRadius = 20
    }
    
    @IBAction func editImage(_ sender: UIButton) {
        if imageView.image != UIImage(named: "camera-large-gray") {
            let alert = UIAlertController(title: "Editar imagem", message: "O que gostaria de fazer?", preferredStyle: .actionSheet)
            let newImageAction = UIAlertAction(title: "Selecionar imagem...", style: .default) { (action) in
                self.selectImage()
            }
            let deleteAction = UIAlertAction(title: "Excluir imagem", style: .destructive) { (action) in
                self.imageView.image = UIImage(named: "camera-large-gray")
            }
            let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
            alert.addAction(newImageAction)
            alert.addAction(deleteAction)
            alert.addAction(cancelAction)
            alert.view.tintColor = .purple
            self.present(alert, animated: true)
        } else {
            selectImage()
        }
    }
    
    func selectPicture(sourceType: UIImagePickerController.SourceType = .savedPhotosAlbum) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
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

    @IBAction func finishAction(_ sender: UIButton) {
        if let image = imageView.image {
            Firebase.shared.uploadPetImage(image: image) { (error) in
                if let error = error {
                    print("Error uploading pet image: \(error.localizedDescription)")
                }
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}

extension EditPetImageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage {
            let proportion: CGFloat = image.size.width / image.size.height
            let imageWidth: CGFloat = 800.00
            let size = CGSize(width: imageWidth, height: imageWidth / proportion)
            UIGraphicsBeginImageContext(size)
            image.draw(in: CGRect(origin: .zero, size: size))
            smallImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            imageView.image = smallImage
            editImageButton.setTitle("Editar imagem...", for: .normal)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
