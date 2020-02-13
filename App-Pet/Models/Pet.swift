//
//  Pet.swift
//  App-Pet
//
//  Created by Lucas Marques Bighi on 07/10/2019.
//  Copyright © 2019 Lucas Marques Bighi. All rights reserved.
//

import Foundation
import UIKit
import FirebaseFirestore

enum PetType: String {
    case dog = "Cachorro"
    case cat = "Gato"
    case none
    
    init(value: String) {
        switch value {
        case "Cachorro":
            self = .dog
        case "Gato":
            self = .cat
        default:
            self = .none
        }
    }
}

enum PetGender: String {
    case male = "Macho"
    case female = "Fêmea"
    case none
    
    init(value: String) {
        switch value {
        case "Macho":
            self = .male
        case "Fêmea":
            self = .female
        default:
            self = .none
        }
    }
}

struct Pet {
    var documentID: String
    var type: String
    var image: UIImage
    var name: String
    var bornDate: Date!
    var age: Int
    var breed: String
    var gender: String
    
//    init(image: UIImage, type: PetType, name: String, bornDate: Date, breed: String, gender: PetGender) {
//        self.image = image
//        self.type = type.rawValue
//        self.name = name
//        self.bornDate = bornDate
//        self.age = Time.current.getAge(from: bornDate)
//        self.breed = breed
//        self.gender = gender.rawValue
//    }
    
    init(documentID: String, image: UIImage, type: String, name: String, bornDate: Date, breed: String, gender: String) {
        self.documentID = documentID
        self.image = image
        self.type = type
        self.name = name
        self.bornDate = bornDate
        self.age = Time.current.getAge(from: bornDate)
        self.breed = breed
        self.gender = gender
    }
    
    init(image: UIImage, type: String, name: String, bornDate: Date, breed: String, gender: String) {
        self.documentID = ""
        self.image = image
        self.type = type
        self.name = name
        self.bornDate = bornDate
        self.age = Time.current.getAge(from: bornDate)
        self.breed = breed
        self.gender = gender
    }
    
    init(type: String, name: String, bornDate: Date, breed: String, gender: String) {
        self.documentID = ""
        self.image = UIImage()
        self.type = type
        self.name = name
        self.bornDate = bornDate
        self.age = Time.current.getAge(from: bornDate)
        self.breed = breed
        self.gender = gender
    }
    
    init?(document: QueryDocumentSnapshot) {
        let data = document.data()
        let type = data["type"] as? String ?? ""
        let name = data["name"] as? String ?? ""
        let bornDate = data["born-date"] as? Date ?? Date()
        let breed = data["breed"] as? String ?? ""
        let gender = data["gender"] as? String ?? ""
        
        self.documentID = document.documentID
        self.image = UIImage()
        self.type = type
        self.name = name
        self.bornDate = bornDate
        self.age = Time.current.getAge(from: bornDate)
        self.breed = breed
        self.gender = gender
    }
}

extension Pet: DatabaseRepresentation {
    var representation: [String : Any] {
        let rep: [String: Any] = [
            "type": type,
            "name": name,
            "born-date": bornDate,
            "age": age,
            "breed": breed,
            "gender": gender
        ]
        return rep
    }
}
