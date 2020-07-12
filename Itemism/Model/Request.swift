//
//  Request.swift
//  Itemism
//
//  Created by 酒井ゆうき on 2020/07/08.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import Foundation

struct Request {
    
    let item : Item
    let requestUser : User
    
    /// not yet
    var message : String?
    
    var accepted = false
   
}
