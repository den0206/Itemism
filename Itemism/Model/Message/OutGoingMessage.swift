//
//  OutGoingMessage.swift
//  Itemism
//
//  Created by 酒井ゆうき on 2020/07/14.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import Foundation
import UIKit


class OutGoingMessage {
    
    let messageDictionary : NSMutableDictionary
    
    /// text init
    
    init(message : String, senderId : String,senderName : String,status : String,type : String) {
        messageDictionary = NSMutableDictionary(objects: [message, senderId, senderName,status,type], forKeys: [kMESSAGE as NSCopying, kSENDERID as NSCopying, kSENDERNAME as NSCopying, kSTATUS as NSCopying,kTYPE as NSCopying ])
    }
    
    // pic
    
    init(message : String, pictureLink : String, senderId : String, senderName : String, status : String, type : String) {
        
        messageDictionary = NSMutableDictionary(objects: [message,pictureLink,senderId,senderName,status,type], forKeys: [kMESSAGE as NSCopying,kPICTURE as NSCopying,kSENDERID as NSCopying, kSENDERNAME as NSCopying, kSTATUS as NSCopying, kTYPE as NSCopying])
        
    }
    
    func sendMessageToFireStore(chatRoomId : String, messageDictionary : NSMutableDictionary, membersIds : [String] ) {
        
        let messageId = UUID().uuidString
        let date = dateFormatter().string(from: Date())
        
        messageDictionary[kMESSAGEID] = messageId
        messageDictionary[kDATE] = date
        
        membersIds.forEach { (member) in
            firebaseReference(.Message).document(member).collection(chatRoomId).document(messageId).setData(messageDictionary as! [String : Any])
        }
        
        let lastMessage = messageDictionary[kMESSAGE] as! String
        
        Recent.updateRecent(chatRoomId: chatRoomId, lastMessage: lastMessage)
        
    }
    
    //MARK: - update read status
    
    class func updateMessageStatus(messageId : String, chatRoomId : String, membersIds : [String]) {
        
        let readDate = dateFormatter().string(from: Date())
        let values = [kSTATUS : kREAD, kREADDATE : readDate]
        
        membersIds.forEach { (memberId) in
            firebaseReference(.Message).document(memberId).collection(chatRoomId).document(messageId).getDocument { (snapshot, error) in
                
                guard let snapshot = snapshot else {return}
                
                if snapshot.exists {
                    firebaseReference(.Message).document(memberId).collection(chatRoomId).document(messageId).updateData(values)
                }
            }
        }
    }
    
    
    
}
