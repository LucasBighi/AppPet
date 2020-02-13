//
//  Message.swift
//  App-Pet
//
//  Created by Lucas Marques Bighi on 17/10/2019.
//  Copyright © 2019 Lucas Marques Bighi. All rights reserved.
//

import Foundation

class Message {
    var message: String?
    var time: String?
    var sender: PUser?
    
    init(sender: PUser, message: String, time: String) {
        self.message = message
        self.time = time
    }
}
