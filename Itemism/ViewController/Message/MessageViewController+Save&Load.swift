//
//  MessageViewController+Save&Load.swift
//  Itemism
//
//  Created by 酒井ゆうき on 2020/07/14.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit

extension MessageViewController {
    
    func send_message(text : String?, picture : UIImage?) {
        
        var outGoingMessage : OutGoingMessage?
        guard let currentUser = User.currentUser() else {return}
        
        if let text = text {
            outGoingMessage = OutGoingMessage(message: text, senderId: currentUser.uid, senderName: currentUser.name, status: kDELIVERED, type: kTEXT)
        }
        
        /// use only text & locationType
        outGoingMessage?.sendMessageToFireStore(chatRoomId: chatRoomId, messageDictionary: outGoingMessage!.messageDictionary, membersIds: membersIds)
        
        
    }
}
