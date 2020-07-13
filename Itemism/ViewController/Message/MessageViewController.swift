//
//  MessageViewController.swift
//  Itemism
//
//  Created by 酒井ゆうき on 2020/07/13.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit
import MessageKit
import InputBarAccessoryView

class MessageViewController : MessagesViewController {
    
    var chatRoomId : String!
    var membersIds : [String]!
    var membersToPush : [String]!

    //MARK: - property
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(chatRoomId!,membersIds!)
    }
    
}
