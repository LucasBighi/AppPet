//
//  PetsViewController.swift
//  App-Pet
//
//  Created by Lucas Marques Bighi on 26/09/2019.
//  Copyright © 2019 Lucas Marques Bighi. All rights reserved.

import UIKit
import FirebaseFirestore
import FirebaseAuth
import FirebaseUI
import FirebaseStorage

class PetsViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var petListener: ListenerRegistration?
    
    var pets = [Pet]()
    var user: User?
    var currentWindow: UIWindow?
    var menuView = MenuView()
    var bgView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPets()
        guard let user = user else { return }
        let usersRef = Firestore.firestore().collection("users").document(user.uid)
        let petsRef = usersRef.collection("pets")
        petListener = petsRef.addSnapshotListener { querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error listening for channel updates: \(error?.localizedDescription ?? "No error")")
                return
            }
            
            snapshot.documentChanges.forEach { change in
                print("Document changed")
                self.handleDocumentChange(change)
            }
        }
        if let user = Auth.auth().currentUser {
            self.user = user
        }
        currentWindow = UIApplication.shared.keyWindow
        setupMenuView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.tabBarController?.tabBar.isHidden = false
//        if let schedules = PUser.shared.schedules {
//            if schedules.lateSchedules() != 0 {
//                self.tabBarController?.tabBar.items![1].badgeValue = String(schedules.lateSchedules())
//            }
//        }
    }
    
    private func handleDocumentChange(_ change: DocumentChange) {
        guard let pet = Pet(document: change.document) else {
            return
        }
        
        switch change.type {
        case .added:
            pets.append(pet)
        default:
            break
        }
    }
    
    func loadPets() {
        Firebase.shared.loadPets() { (pets) in
            if let pets = pets {
                self.pets = pets
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    func setupMenuView() {
        bgView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        bgView.backgroundColor = UIColor.darkGray
        bgView.alpha = 0
        bgView.frame = CGRect(x: -self.view.frame.width, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        currentWindow?.addSubview(bgView)
        menuView = MenuView.instanceFromNib()
        menuView.frame = CGRect(x: -self.view.frame.width, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        menuView.logoutButton.addAction {
            let sb = UIStoryboard(name: "Login", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "Login")
            self.present(vc, animated: true)
            self.menuView.removeFromSuperview()
            self.bgView.removeFromSuperview()
        }
        menuView.closeButton.addAction {
            self.showMenu(false)
        }
        currentWindow?.addSubview(menuView)
    }
    
    func showMenu(_ show: Bool) {
        bgView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        if show {
            UIView.animate(withDuration: 0.5) {
               self.menuView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
                self.bgView.alpha = 0.8
            }
        } else {
            UIView.animate(withDuration: 0.5, animations: {
                self.menuView.frame = CGRect(x: -self.view.frame.width, y: 0, width: self.view.frame.width, height: self.view.frame.height)
                self.bgView.alpha = 0
            }) { (completed) in
                self.bgView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
            }
        }
        self.view.layoutIfNeeded()
    }
    
    @IBAction func menuAction(_ sender: UIBarButtonItem) {
        showMenu(true)
    }
    
}

extension PetsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pets.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row < pets.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PetsCollectionViewCell
            let pet = pets[indexPath.row]
            //cell.petImageView.image = pet.image
            let ref = Storage.storage().reference(withPath: "pets-profile-images/\(pet.documentID).jpeg")
            cell.petImageView.sd_setImage(with: ref)
            cell.petNameLabel.text = pet.name
            let labelLayer = cell.petNameLabel.layer
            labelLayer.shadowRadius = 3
            labelLayer.shadowOpacity = 1
            labelLayer.shadowOffset = CGSize(width: 4, height: 4)
            labelLayer.masksToBounds = false
            let contentLayer = cell.contentView.layer
            let cellLayer = cell.layer
            contentLayer.cornerRadius = 10
            contentLayer.borderWidth = 1.0
            contentLayer.borderColor = UIColor.clear.cgColor
            contentLayer.masksToBounds = true
            cellLayer.cornerRadius = 10
            cellLayer.shadowColor = UIColor.gray.cgColor
            cellLayer.shadowOffset = CGSize(width: 0, height: 3)
            cellLayer.shadowRadius = 5
            cellLayer.shadowOpacity = 1
            cellLayer.masksToBounds = false
            cellLayer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: contentLayer.cornerRadius).cgPath
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "addCell", for: indexPath)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let pet = pets[indexPath.row]
        let storyboard = UIStoryboard(name: "Pets", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PetDetail") as! PetDetailViewController
        vc.pet = pet
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.size.width-28)/2
        return CGSize(width: width, height: 250)
    }
}
