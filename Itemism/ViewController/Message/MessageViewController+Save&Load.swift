//
//  MessageViewController+Save&Load.swift
//  Itemism
//
//  Created by 酒井ゆうき on 2020/07/14.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit
import FirebaseFirestore

//MARK: - Send


extension MessageViewController {
    
    
    func send_message(text : String?, picture : UIImage?) {
        
        var outGoingMessage : OutGoingMessage?
        guard let currentUser = User.currentUser() else {return}
        
        if let text = text {
            outGoingMessage = OutGoingMessage(message: text, senderId: currentUser.uid, senderName: currentUser.name, status: kDELIVERED, type: kTEXT)
        }
        
        if let pic = picture {
            
            uploadMessageImage(image: pic, chatRoomId: chatRoomId) { (imageLink) in
                
                guard let imageLink = imageLink else {
                    self.navigationController?.showPresentLoadindView(false)
                    self.showAlert(title: "Error", message: "画像が送れませんでした。")
                    return}
                
                let text = "画像が送信されました"
                
                let outGoingMessage = OutGoingMessage(message: text, pictureLink: imageLink, senderId: currentUser.uid, senderName: currentUser.name, status: kDELIVERED, type: kPICTURE)
                
                outGoingMessage.sendMessageToFireStore(chatRoomId: self.chatRoomId, messageDictionary: outGoingMessage.messageDictionary, membersIds: self.membersIds)
                
            }
            
            self.navigationController?.showPresentLoadindView(false)
            finishSendMessage()

            return
        }
        
        /// use only text & locationType
        outGoingMessage?.sendMessageToFireStore(chatRoomId: chatRoomId, messageDictionary: outGoingMessage!.messageDictionary, membersIds: membersIds)
        
    }
}

//MARK: - Load

extension MessageViewController {
    
    
    
    func loadFirstMessage() {
        
        /// atach messageLisner 
        
        newChatListner = firebaseReference(.Message).document(User.currentId()).collection(chatRoomId).order(by: kDATE, descending: true).limit(to: 11).addSnapshotListener({ (snapshot, error) in
            
            guard let snapshot = snapshot else {return}
            
            if !snapshot.isEmpty {
                
                 let sorted = ((dictionaryFromSnapshots(snapshots: snapshot.documentChanges)) as NSArray).sortedArray(using: [NSSortDescriptor(key: kDATE, ascending: true)]) as! [NSDictionary]
                
                sorted.forEach { (message) in
                    self.appendMessage(messageDictionary: message)
                }
                
                self.lastDocument = snapshot.documents.last
                
                DispatchQueue.main.async {
                    self.messagesCollectionView.scrollToLastItem()
                }
            }
        })
        
    }
    
    func fetchMoreMessage() {
        
        guard let lastDocument = lastDocument else {return}
        print(lastDocument)
    }
    
    //MARK: - Helpers
    
    private func appendMessage(messageDictionary : NSDictionary) {
        let incomingMessage = IncomingMessage(_collectionView: self.messagesCollectionView)
        
        if isInComing(messageDictionary: messageDictionary) {
            /// update read Status
            
            let messageId = messageDictionary[kMESSAGEID] as! String
            
            OutGoingMessage.updateMessageStatus(messageId: messageId, chatRoomId: chatRoomId, membersIds: membersIds)
            
        }
        
        let message = incomingMessage.createMessage(messageDictionary: messageDictionary, chatRoomId: chatRoomId)
        
        if message != nil {
            
            messageLists.append(message!)
            objectMessages.append(messageDictionary)
        }
        
        
    }
    
    private func isInComing(messageDictionary : NSDictionary) -> Bool {
        
        var inComing = (User.currentId() == messageDictionary[kSENDERID] as! String) ? false : true
        
        return inComing
    }
    
    
}
