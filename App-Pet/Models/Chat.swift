//
//  Chat.swift
//  App-Pet
//
//  Created by Lucas Marques Bighi on 16/10/2019.
//  Copyright © 2019 Lucas Marques Bighi. All rights reserved.
//

import Foundation

class Chat {
    var sender: PUser?
    var messages: [Message]?
    var lastMessage: Message?
    
    init(messages: [Message]) {
        self.sender = lastMessage?.sender
        self.messages = messages
        self.lastMessage = messages.last
    }
}
