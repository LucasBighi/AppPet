//
//  User.swift
//  App-Pet
//
//  Created by Lucas Marques Bighi on 11/10/2019.
//  Copyright © 2019 Lucas Marques Bighi. All rights reserved.
//

import Foundation
import UIKit

class PUser {
    
    static let shared = PUser()
    
    var email: String?
    var password: String?
    var name: String?
    var image: UIImage?
    var pets: [Pet]?
    var chats: [Chat]?
    var schedules: [Schedule]?
    
    private init(){}
}
