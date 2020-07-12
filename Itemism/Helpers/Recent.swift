//
//  Recent.swift
//  Itemism
//
//  Created by 酒井ゆうき on 2020/07/12.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit

class Recent {
    static func startPrivateChat(currentUserId : String, match :Match) -> String {
        
        let mathedUserId = match.uid
        var chatRoomId = ""
        let value = currentUserId.compare(mathedUserId).rawValue
        
        if value < 0 {
            chatRoomId = currentUserId + mathedUserId
        } else {
            chatRoomId = mathedUserId + currentUserId
        }
        
        let members = [currentUserId,mathedUserId]
        
        createRecentChat(members: members, chatRoomId: chatRoomId, withMatch: match)
        
        return chatRoomId
    }
    
    static func createRecentChat(members : [String] ,chatRoomId : String, withMatch : Match) {
        
        var tempMembers = members
        
        firebaseReference(.Recent).whereField(kCHATROOMID, isEqualTo: chatRoomId).getDocuments { (snapshot, error) in
            
            guard let snapshot = snapshot else {return}
            
            if !snapshot.isEmpty {
                for doc in snapshot.documents {
                    let currentRecent = doc.data()
                    
                    if let currentUserId = currentRecent[kUSERID] {
                        if members.contains(currentUserId as! String) {
                            tempMembers.remove(at: tempMembers.firstIndex(of: currentUserId as! String)!)
                        }
                    }
                }
            }
            
            /// return if exist recent
            
            guard !tempMembers.isEmpty else {print("already")
                return
            }
            
            /// no dupicate
            
            for userId in tempMembers {
                ///set FireStore
                createRecentToFireStore(userId: userId, chatRoomId: chatRoomId, members: members, withMatch: withMatch)
            }
        }
    }
    
    static func createRecentToFireStore(userId : String,chatRoomId : String,members : [String], withMatch : Match) {
        
        let localReference = firebaseReference(.Recent).document()
        let recentId = localReference.documentID
        
        let date = dateFormatter().string(from: Date())
        
        var recent : [String : Any]!

        var MatchedUser : Match?
        
        if userId == User.currentId() {
            MatchedUser = withMatch
        } else {
            
            /// currentUser
            MatchedUser = Match(uid: User.currentId(), name: User.currentUser()!.name, profileImageData: User.currentUser()!.profileImageData)
        }
        
        recent = [kRECENTID : recentId,
                  kUSERID : userId,
                  kCHATROOMID : chatRoomId,
                  kMEMBERS : members,
                  kMEMBERSTOPUSH : members,
                  kWITHUSERFULLNAME : MatchedUser!.name,
                  kWITHUSERUSERID : MatchedUser!.uid,
                  kLASTMESSAGE : "",
                  kCOUNTER : 0,
                  kDATE : date,
                  kPROFILE_IMAGE : MatchedUser!.profileImageData ] as [String : Any]
        
        localReference.setData(recent)
        
    }
    
}
