//
//  MatchViewModel.swift
//  Itemism
//
//  Created by 酒井ゆうき on 2020/07/11.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit

struct MatchViewModel {
    let curretUser : User
    let matchUser : User
    
    let matchLabelText : String
    
    var currentUserImage : UIImage?
    var matchUserImage : UIImage?
    
    init(currentUser : User, matchUser : User) {
        self.curretUser = currentUser
        self.matchUser = matchUser
        
        self.matchLabelText = "\(matchUser.name)さんへメッセージが送れます。"
        
        self.currentUserImage = downloadImageFromData(picturedata: curretUser.profileImageData)
        self.matchUserImage = downloadImageFromData(picturedata: matchUser.profileImageData)
        
    }
}
