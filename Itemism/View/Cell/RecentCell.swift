//
//  RecentCell.swift
//  Itemism
//
//  Created by 酒井ゆうき on 2020/07/12.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit


class RecentCell : UITableViewCell {
    
    var recent : [String : Any]? {
        didSet {
            configure()
        }
    }
    
    let profileImageView : UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.setDimensions(height: 48, width: 48)
        iv.layer.cornerRadius = 48 / 2
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    private let withUserNameLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.text = "User name"
        return label
    }()
    
    private let lastMessageLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "Last message"
        return label
    }()
    
    private let dateLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "3/5"
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        selectionStyle = .default
        
        addSubview(profileImageView)
        profileImageView.centerY(inView: self)
        profileImageView.anchor(left : leftAnchor, paddingLeft: 16)
        
        addSubview(withUserNameLabel)
        withUserNameLabel.anchor(top : topAnchor, left:  profileImageView.rightAnchor,paddingTop: 24, paddingLeft: 24)
        
        addSubview(lastMessageLabel)
        lastMessageLabel.anchor(top : withUserNameLabel.bottomAnchor, left:  profileImageView.rightAnchor,paddingTop: 8,paddingLeft: 24)
        
        addSubview(dateLabel)
        dateLabel.anchor(top : topAnchor, right: rightAnchor,paddingTop: 12,paddingRight: 36)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // user Dictionary without VM
    
    func configure() {
        guard let recent = recent else {return}
       
        
        withUserNameLabel.text = recent[kWITHUSERFULLNAME] as? String
        self.lastMessageLabel.text = recent[kLASTMESSAGE] as? String
        
        var date : Date!
        
        if let created = recent[kDATE] {
            if (created as! String).count != 14 {
                date = Date()
            } else {
                date = dateFormatter().date(from: created as! String)!
            }
        } else {
            date = Date()
        }
        
        self.dateLabel.text = timeElapsed(date: date)
        
        if let profileImage = recent[kPROFILE_IMAGE] {
            let profileImage = downloadImageFromData(picturedata: profileImage as! String)
            
            self.profileImageView.image = profileImage
        }
        
        
        
        
    }
}


