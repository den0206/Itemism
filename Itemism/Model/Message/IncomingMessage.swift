//
//  IncomingMessage.swift
//  Itemism
//
//  Created by 酒井ゆうき on 2020/07/16.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//


import Foundation
import MessageKit

struct IncomingMessage {
    
    let collectionView : MessagesCollectionView
    
    init(_collectionView: MessagesCollectionView) {
        collectionView = _collectionView
    }
    
    //MARK: - return MessageType
    
    func createMessage(messageDictionary : NSDictionary, chatRoomId : String) -> Message? {
        
        var message : Message?
        let type = messageDictionary[kTYPE] as! String
        
        switch type {
        case kTEXT:
            message = textMessage(messageDictionary: messageDictionary, chatRoomId: chatRoomId)
        case kPICTURE:
            print("Picture")
        default:
            print("Typeがわかりません")
        }
        
        guard message != nil else { return nil }
        
        return message
    }
    
    /// text
    
    func textMessage(messageDictionary : NSDictionary, chatRoomId : String) -> Message {
        
        let name = messageDictionary[kSENDERNAME] as! String
        let userid = messageDictionary[kSENDERID] as! String
        let messageId = messageDictionary[kMESSAGEID] as! String
        
        var date : Date!
        
        if let created = messageDictionary[kDATE] {
            if (created as! String).count !=  14 {
                date = Date()
            } else {
                date = dateFormatter().date(from: created as! String)
            }
        } else {
            date = Date()
        }
        
        let text = messageDictionary[kMESSAGE] as! String
        
        return Message(text: text, sender: Sender(senderId: userid, displayName: name), messageId: messageId, date: date)
    }
}
