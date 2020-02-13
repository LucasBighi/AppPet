//
//  ChatsViewController.swift
//  App-Pet
//
//  Created by Lucas Marques Bighi on 16/10/2019.
//  Copyright © 2019 Lucas Marques Bighi. All rights reserved.
//

import UIKit

class ChatsViewController: UIViewController {
    
    var chats: [Chat] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        let message1 = Message(sender: PUser.shared, message: "Me dá seu cachorro?", time: "12:34")
        let message2 = Message(sender: PUser.shared, message: "Não", time: "12:35")
        let messagesArr: [Message] = [message1, message2]
        
        let chat1 = Chat(messages: messagesArr)
        let chat2 = Chat(messages: messagesArr)
        chats.append(chat1)
        chats.append(chat2)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.tabBarController?.tabBar.isHidden = false
    }

}

extension ChatsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ChatsTableViewCell
        cell.chatNameLabel.text = chats[indexPath.row].sender?.name
        cell.lastMessageTextLabel.text = chats[indexPath.row].lastMessage?.message
        cell.chatImageView.image = chats[indexPath.row].sender?.image
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Chat", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Message") as! MessagesViewController
        if let messages = chats[indexPath.row].messages {
            vc.messages = messages
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
