//
//  CardViewModel.swift
//  Itemism
//
//  Created by 酒井ゆうき on 2020/06/28.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import Foundation

class CardViewModel {
    
    let item : Item
    let imageUrls : [String]
    
    let itemNameText : String
    
    init(item : Item) {
        self.item = item
        self.itemNameText = item.name
        
        self.imageUrls = item.imageLinks
        
    }
    
}
