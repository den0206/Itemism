//
//  DetailUserCell.swift
//  Itemism
//
//  Created by 酒井ゆうき on 2020/07/19.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit

class SettingUserCell  : UITableViewCell{
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .black
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
