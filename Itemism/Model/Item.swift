//
//  Item.swift
//  Itemism
//
//  Created by 酒井ゆうき on 2020/06/25.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import Foundation
import Firebase

struct Item {
    let id : String
    var name : String
    var description : String
    var imageLinks : [String]
    var wanted = false
    
    let userId : String
    
    var user : User?
    
  
    init(dictionry : [String : Any]) {
        id = dictionry[kITEMID] as? String ?? ""
        userId = dictionry[kUSERID] as? String ?? ""
        name = dictionry[kITEMNAME] as? String ?? ""
        description = dictionry[kDESCRIPTION] as? String ?? ""
        imageLinks = dictionry[kIMAGELINKS] as? [String] ?? [String()]
    }
    
}

func saveItemToFirestore(itemId : String,value : [String : Any], completion :  @escaping(_ Error : Error?) -> Void){
    
    firebaseReference(.Item).document(itemId).setData(value, completion: completion)
}

func updateItemToFireStore(item : Item, completion : @escaping(Error?) -> Void) {
    
    let value = [kITEMNAME : item.name,
                 kDESCRIPTION : item.description,
                 kTIMESTAMP : Timestamp(date: Date()),
                 kIMAGELINKS : item.imageLinks] as [String : Any]
    
    firebaseReference(.Item).document(item.id).updateData(value, completion: completion)
}
