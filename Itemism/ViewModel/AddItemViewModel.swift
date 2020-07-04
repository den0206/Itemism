//
//  AddItemViewModel.swift
//  Itemism
//
//  Created by 酒井ゆうき on 2020/06/23.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import Foundation

enum itemtemSections : Int, CaseIterable {
    case name
    case description
    
    var title : String {
        switch self {
        case .name:
            return "Name"
        case .description :
            return "Description"
        }
    }
}

class ItemViewModel {
    var section : itemtemSections
    var placeholder : String
    
    var shoulHideInputField : Bool {
        return section == .description
    }
    
    var shoulHideTextView : Bool {
        return section != .description
        
    }
    
    init(section : itemtemSections) {
        self.section = section
        
        placeholder = section.title
    }
}

//MARK: - New Item

class AddItemViewModel : ItemViewModel{
    
//    let section : itemtemSections
//    let placeholder : String
//
//    var shoulHideInputField : Bool {
//        return section == .description
//    }
//
//    var shoulHideTextView : Bool {
//        return section != .description
//
//    }
//
//    init(section : itemtemSections) {
//        self.section = section
//
//        placeholder = section.title
//    }
}

//MARK: - Edit Item

class EditItemViewModel : ItemViewModel{
    
    private let item : Item
    var value : String?
   
 
    
    init(item : Item,section : itemtemSections) {
        self.item = item
        super.init(section: section)
        
//        self.section = section
        
//        placeholder = section.title
        
        switch section {
        case .name:
            value = item.name
        case .description:
            value = item.description
        }
    }
}

