//
//  SettingViewModel.swift
//  Itemism
//
//  Created by 酒井ゆうき on 2020/07/19.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit

enum SettingSections : Int, CaseIterable {
    case name
    case bio
    
    var description : String {
        switch self {
        
        case .name:
            return "Name"
        case .bio:
            return "Bio"
        }
    }
}

struct settingViewModel {
    
    private let user : User
    
    var userType : UserType{
        return user.userType
    }
    let section : SettingSections
    
    let placeholderText : String
    let value : String?
    
    var shouldHideInputView : Bool {
        return section == .bio
    }
    var isEnable : Bool {
        return userType == .current
    }
    
    var sholdHideTextView : Bool {
        return section != .bio
    }
    
    init(user : User, section : SettingSections) {
        self.user = user
        self.section = section
        
        placeholderText = section.description
        
        switch section {
        
        case .name:
            value = user.name
        case .bio:
            value = user.bio
        }
    }
    
    
    
}
