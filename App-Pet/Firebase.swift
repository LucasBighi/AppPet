//
//  Firebase.swift
//  App-Pet
//
//  Created by Lucas Marques Bighi on 31/10/2019.
//  Copyright © 2019 Lucas Marques Bighi. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

protocol FirebaseUserDelegate: NSObjectProtocol {
    func didSuccessOnLogin()
    func didErrorOnLogin(error: Error)
    func didErrorOnCheckEmail(error: Error)
    func didSuccessOnCreateUser()
    func didErrorOnCreateUser(error: Error)
    func didSuccessOnChangeName()
    func didErrorOnChangeName(error: Error)
}

class Firebase {
    
    static var shared = Firebase()
    weak var delegate: FirebaseUserDelegate?
    
    //MARK: Auth vars
    var auth = Auth.auth()
    var user: User?
    
    //MARK: Storage vars
    let ref = Storage.storage().reference()
    
    //MARK: Auth methods
    func login(email: String, password: String) {
        auth.signIn(withEmail: email, password: password) {result, error in
            if let error = error {
                self.delegate?.didErrorOnLogin(error: error)
            }
            if let user = result?.user {
                self.user = user
                self.delegate?.didSuccessOnLogin()
            }
        }
    }
    
    func checkEmailIsUsed(email: String, isUsed: @escaping (Bool?) -> Void) {
        auth.fetchSignInMethods(forEmail: email) { (providers, error) in
            if let error = error {
                self.delegate?.didErrorOnCheckEmail(error: error)
            } else {
                isUsed(false)
            }
            if let providers = providers {
                if !providers.isEmpty {
                    isUsed(true)
                }
            }
        }
    }
    
    func createUser(email: String, password: String) {
        auth.createUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                self.delegate?.didErrorOnCreateUser(error: error)
                return
            }
            if let user = result?.user {
                self.user = user
                self.delegate?.didSuccessOnCreateUser()
            }
        }
    }
    
    func changeNameRequest(user : User, name: String) {
        let changeRequest = user.createProfileChangeRequest()
        changeRequest.displayName = name
        changeRequest.commitChanges(completion: { (error) in
            if let error = error {
                self.delegate?.didErrorOnChangeName(error: error)
                return
            }
            self.delegate?.didSuccessOnChangeName()
        })
    }
    
    //MARK: Firestore methods
    func registerUserInDatabase(_ petOwner: PetUser, completion: @escaping (Error?) -> Void) {
        guard let user = user else { return }
        let usersRef = Firestore.firestore().collection("users").document(user.uid)
        usersRef.setData(petOwner.representation, completion: { (error) in
            if let error = error {
                //print("Error: \(error.localizedDescription)")
                completion(error)
                return
            }
            completion(nil)
        })
    }
    
    func registerPetInDatabase(_ pet: Pet, completion: @escaping (Error?, _ completed: Bool) -> Void) {
        guard let user = user else { return }
        let usersRef = Firestore.firestore().collection("users").document(user.uid)
        let petsDoc = usersRef.collection("pets").document()
        //Register in database
        petsDoc.setData(pet.representation) { (error) in
            if let error = error {
                completion(error, true)
            } else {
                //Upload image
                let storageRef = self.ref.child("pets-profile-images/\(petsDoc.documentID).jpeg")
                if let uploadData = pet.image.jpegData(compressionQuality: 0.5) {
                    let metadata = StorageMetadata()
                    metadata.contentType = "image/jpeg"
                    storageRef.putData(uploadData, metadata: metadata) { (metadata, error) in
                        if let error = error {
                            print("Error uploading pet image: \(error.localizedDescription)")
                        } else {
                            print("Pet image upload complete")
                            completion(nil, true)
                        }
                    }
                }
            }
        }
    }
    
    func loadPets(completion: @escaping ([Pet]?) -> Void) {
        guard let user = user else { return }
        //Load data from database
        let usersRef = Firestore.firestore().collection("users").document(user.uid)
        let petsRef = usersRef.collection("pets")
        petsRef.getDocuments { (snapshot, error) in
            if let error = error {
                print("Error geting pets: \n\(error.localizedDescription)")
                completion(nil)
                return
            }
            if let snapshot = snapshot {
                var pets = [Pet]()
                for document in snapshot.documents {
                    let data = document.data()
                    let type = data["type"] as? String ?? ""
                    let name = data["name"] as? String ?? ""
                    let bornDate = data["born-date"] as? Date ?? Date()
                    let breed = data["breed"] as? String ?? ""
                    let gender = data["gender"] as? String ?? ""
                    var petImage: UIImage?
                    self.downloadImage(folder: "pets-profile-images", imageName: document.documentID, success: { (image) in
                        if let image = image {
                            petImage = image
                        }
                    }, failure: { (error) in
                        print("Error geting pet image: \n\(error.localizedDescription)")
                    })
                    let newPet = Pet(documentID: document.documentID, image: petImage ?? UIImage(), type: type, name: name, bornDate: bornDate, breed: breed, gender: gender)
                    pets.append(newPet)
                    completion(pets)
                }
            }
        }
    }
    
    //MARK: Storage methods
    func uploadUserImage(image: UIImage, completion: @escaping (_ url: String?) -> Void) {
        guard let user = user else { return }
        let storageRef = ref.child("users-profile-images/\(user.uid).jpeg")
        if let uploadData = image.jpegData(compressionQuality: 0.5) {
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            storageRef.putData(uploadData, metadata: metadata) { (metadata, error) in
                if error != nil {
                    print("error")
                    completion(nil)
                } else {
                    storageRef.downloadURL(completion: { (url, error) in
                        //print(url?.absoluteString)
                        completion(url?.absoluteString)
                    })
                    //  completion((metadata?.downloadURL()?.absoluteString)!))
                    // your uploaded photo url.
                }
            }
        }
    }
    
    func uploadPetImage(image: UIImage, completion: @escaping (_ error: Error?) -> Void) {
        guard let user = user else { return }
        //Actually uploads and download image in background
        let usersRef = Firestore.firestore().collection("users").document(user.uid)
        let petsDoc = usersRef.collection("pets").document()
        let storageRef = ref.child("pets-profile-images/\(petsDoc.documentID).jpeg")
        if let uploadData = image.jpegData(compressionQuality: 0.5) {
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            storageRef.putData(uploadData, metadata: metadata) { (metadata, error) in
                if error != nil {
                    completion(error)
                } else {
                    completion(nil)
                }
            }
        }
    }
    
    func downloadImage(folder: String, imageName: String, success: @escaping (_ image: UIImage?) -> (),failure: @escaping (_ error: Error) -> ()) {
        let path = "\(folder)/\(imageName)"
        for _ in 0 ..< 194 {
            let reference = Storage.storage().reference(withPath: "\(path).jpeg")
            reference.getData(maxSize: (1 * 1024 * 1024)) { (data, error) in
                if let _error = error{
                    print(_error)
                    failure(_error)
                } else {
                    if let _data  = data {
                        let myImage: UIImage! = UIImage(data: _data)
                        success(myImage)
                    }
                }
            }
        }
    }
    
    private init() {}
}
