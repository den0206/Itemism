//
//  AddItemViewModel.swift
//  Itemism
//
//  Created by 酒井ゆうき on 2020/06/23.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import Foundation

enum AddItemSections : Int, CaseIterable {
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

struct AddItemViewModel {
    
    let section : AddItemSections
    let placeholder : String
    
    var shoulHideInputField : Bool {
        return section == .description
    }
    
    var shoulHideTextView : Bool {
        return section != .description
        
    }
    
    init(section : AddItemSections) {
        self.section = section
        
        placeholder = section.title
    }
}

