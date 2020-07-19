//
//  profileHeaderView.swift
//  Itemism
//
//  Created by 酒井ゆうき on 2020/07/19.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit

class UserProfileHeaderView : UIView {
    
    let userImage : UIImage
    
    //MARK: - parts
    
    private lazy var userImageView : UIImageView = {
        let iv = UIImageView()
        iv.setDimensions(height: 70, width: 70)
        iv.layer.cornerRadius = 70 / 2
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .lightGray
        iv.image = userImage
        return iv
    }()
    
    init(userImage : UIImage) {
        self.userImage = userImage
        super.init(frame: .zero)
        
        backgroundColor = .systemGroupedBackground
        
        addSubview(userImageView)
        userImageView.center(inView: self)
        
    }

    
   
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
