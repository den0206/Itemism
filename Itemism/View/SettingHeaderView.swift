//
//  profileHeaderView.swift
//  Itemism
//
//  Created by 酒井ゆうき on 2020/07/19.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit

protocol SettingHeaderViewDelegate : class {
    func tappedImage()
}

class SettingHeaderView : UIView {
    
    let userImage : UIImage
    weak var delegate : SettingHeaderViewDelegate?
    
    //MARK: - parts
    
    lazy var userImageView : UIImageView = {
        let iv = UIImageView()
        iv.setDimensions(height: 70, width: 70)
        iv.layer.cornerRadius = 70 / 2
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .lightGray
        iv.image = userImage
        iv.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tappedImage))
        iv.addGestureRecognizer(tap)
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
    
    //MARK: - Actions
    
    @objc func tappedImage() {
        delegate?.tappedImage()
    }
}
