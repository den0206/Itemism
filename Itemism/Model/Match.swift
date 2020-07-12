//
//  Match.swift
//  Itemism
//
//  Created by 酒井ゆうき on 2020/07/12.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import Foundation

struct Match {
    
    let name : String
    let profileImageData : String
    let uid : String
    
    init(dictionary : [String : Any]) {
        self.name = dictionary[kFULLNAME] as? String ?? ""
        self.profileImageData = dictionary[kPROFILE_IMAGE] as? String ?? ""
        self.uid = dictionary[kUSERID] as? String ?? ""
    }
    
    init(uid : String,name: String, profileImageData : String) {
        self.uid = uid
        self.name = name
        self.profileImageData = profileImageData
    }
}
