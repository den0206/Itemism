//
//  Item.swift
//  Itemism
//
//  Created by 酒井ゆうき on 2020/06/25.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import Foundation

struct Item {
    let id : String
    var name : String
    var description : String
    var imageLinks : [String]
    
    let userId : String
    
  
    init(dictionry : [String : Any]) {
        id = dictionry[kITEMID] as? String ?? ""
        userId = dictionry[kUSERID] as? String ?? ""
        name = dictionry[kITEMNAME] as? String ?? ""
        description = dictionry[kDESCRIPTION] as? String ?? ""
        imageLinks = dictionry[kIMGELINKS] as? [String] ?? [String()]
    }
    
}
