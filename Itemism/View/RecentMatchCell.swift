//
//  RecentMatchCell.swift
//  Itemism
//
//  Created by 酒井ゆうき on 2020/07/12.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit

class RecentMatchCell : UICollectionViewCell {
    
    var match : Match? {
        didSet {
            configureUI()
        }
    }
    
    //MARK: - Parts
    
    private let profileImageView : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.borderWidth = 2
        iv.layer.backgroundColor = UIColor.white.cgColor
        iv.setDimensions(height: 80, width: 80)
        iv.layer.cornerRadius = 80 / 2
        
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    private let usernameLabel : UILabel = {
        
        let label = UILabel()
        label.text = "username"
        label.font = UIFont.systemFont(ofSize: 14,weight: .semibold)
        label.textColor = .darkGray
        label.textAlignment = .center
        label.numberOfLines = 0
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        
        let stack = UIStackView(arrangedSubviews: [profileImageView,usernameLabel])
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.alignment = .center
        stack.spacing = 6
        
        addSubview(stack)
        stack.fillSuperview()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI
    
    private func configureUI() {
        guard let match = match else {return}
        self.usernameLabel.text = match.name
        self.profileImageView.image = downloadImageFromData(picturedata: match.profileImageData)
    }
}
