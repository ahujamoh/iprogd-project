//
//  Conversation.swift
//  Moodstory
//
//  Created by Mohit on 09/04/17.
//  Copyright © 2017 MoodStory. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class Conversation {
    
    //MARK: Properties
    let user: User
    var lastMessage: Message
    
    //MARK: Methods
    class func showConversations(completion: @escaping ([Conversation]) -> Swift.Void) {
        if let currentUserID = FIRAuth.auth()?.currentUser?.uid {
            var conversations = [Conversation]()
            //put some stuff here.
            let user_item = User.init(name: "Test", email: "test@test.com", id: "test", profilePic: UIImage(named: "profile pic")!)
            let message_item = Message.init(type: MessageType.text, content: "test data", owner: MessageOwner.receiver, timestamp: 9999999999, isRead: false)
            let convo_item = Conversation.init(user: user_item, lastMessage: message_item)
            conversations.append(convo_item)
            completion(conversations)
//            FIRDatabase.database().reference().child("users").child(currentUserID).child("conversations").observe(.childAdded, with: { (snapshot) in
//                if snapshot.exists() {
//                    let fromID = snapshot.key
//                    let values = snapshot.value as! [String: String]
//                    let location = values["location"]!
//                    User.info(forUserID: fromID, completion: { (user) in
//                        let emptyMessage = Message.init(type: .text, content: "loading", owner: .sender, timestamp: 0, isRead: true)
//                        let conversation = Conversation.init(user: user, lastMessage: emptyMessage)
//                        conversations.append(conversation)
//                        conversation.lastMessage.downloadLastMessage(forLocation: location, completion: { (_) in
//                            completion(conversations)
//                        })
//                    })
//                }
//            })
        }
    }
    
    //MARK: Inits
    init(user: User, lastMessage: Message) {
        self.user = user
        self.lastMessage = lastMessage
    }
}
