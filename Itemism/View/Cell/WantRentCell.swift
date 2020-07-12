//
//  WantRentCell.swift
//  Itemism
//
//  Created by 酒井ゆうき on 2020/07/08.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit

class WantRentCell : UICollectionViewCell {
    
    //MARK: - Property
    
    var item : Item? {
        didSet {
            configure()
        }
    }
    
    //MARK: - Parts
    
    private let itemImageView : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleToFill
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    private let userImageView : UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .lightGray
        iv.setDimensions(height: 35, width: 35)
        iv.layer.cornerRadius = 35 / 2
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 13 / 2
        clipsToBounds = true
        
        addSubview(itemImageView)
        itemImageView.fillSuperview()
        
        addSubview(userImageView)
        userImageView.anchor(top : itemImageView.topAnchor,right: itemImageView.rightAnchor, paddingTop: 8,paddingRight: 8)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Actions
    
    private func configure() {
        
        ///image url
        guard let item = item else {return}
        let imageUrl = URL(string: item.imageLinks[0])
        itemImageView.sd_setImage(with: imageUrl)
        
        ///image data
        let userImage = downloadImageFromData(picturedata: item.user!.profileImageData)
        userImageView.image = userImage
    }
}


