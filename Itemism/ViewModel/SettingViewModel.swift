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
