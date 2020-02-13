//
//  PetUser.swift
//  App-Pet
//
//  Created by Lucas Marques Bighi on 30/10/2019.
//  Copyright © 2019 Lucas Marques Bighi. All rights reserved.
//

import Foundation

struct PetUser {
    
    var name: String
    var imgUrl: String
    var pets: [Pet]
    
    var dictionary: [String: Any] {
        return [
            "name": name,
            "img-url": imgUrl,
            "pets": pets
        ]
    }
    
    init(name: String, imgUrl: String) {
        self.name = name
        self.imgUrl = imgUrl
        self.pets = [Pet]()
    }
}

extension PetUser: DatabaseRepresentation {
    
    var representation: [String : Any] {
        let rep: [String : Any] = [
            "name": name,
            "img-url": imgUrl,
            "pets": pets
        ]
        return rep
    }
}
