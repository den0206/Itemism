//
//  DetailItemCell.swift
//  Itemism
//
//  Created by 酒井ゆうき on 2020/07/18.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit

class DetailItemCell : UICollectionViewCell {
    
    var imageUrlString : String? {
        didSet {
            downloadImage()
        }
    }
    
    let itemImageView : UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .lightGray
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 35 / 2
    
        iv.clipsToBounds = true
        
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        layer.cornerRadius = 35 / 2
        
        addSubview(itemImageView)
        itemImageView.fillSuperview()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI
    
    private func  downloadImage() {
        guard let imageUrl = URL(string: imageUrlString!) else {return}
        
        itemImageView.sd_setImage(with: imageUrl)
    }

}
