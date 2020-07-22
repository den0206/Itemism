//
//  User.swift
//  Itemism
//
//  Created by 酒井ゆうき on 2020/06/21.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import Foundation
import FirebaseAuth

class User {
    
    var name : String
    
    let email : String
    let uid : String
    var profileImageData : String
    
    var bio : String
    
    var userType : UserType {
        if self.uid == User.currentId() {
            return .current
        } else {
            return .another
        }
    }
    
    init(dictionary : [String : Any]) {
        self.name = dictionary[kFULLNAME] as? String ?? ""
        self.email = dictionary[kEMAIL] as? String ?? ""
        self.uid = dictionary[kUSERID] as? String ?? ""
        self.profileImageData = dictionary[kPROFILE_IMAGE] as? String ?? ""
        self.bio = dictionary[kBIO] as? String ?? ""
    }
    
    class func currentId() -> String {
        
        guard let currentUser = Auth.auth().currentUser else {return ""}
        
        return currentUser.uid
    }
       
    
    class func currentUser() -> User? {
        if Auth.auth().currentUser != nil {
            
            if let dictiobnary = UserDefaults.standard.object(forKey: kCURRENTUSER) {
                
                return User(dictionary: dictiobnary as! [String : Any])
            }
        }
        
        return nil
    }
    
}

enum UserType {
    case current
    case another
}
