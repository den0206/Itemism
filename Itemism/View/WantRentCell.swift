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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 13 / 2
        
        addSubview(itemImageView)
        itemImageView.fillSuperview()
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Actions
    
    private func configure() {
        
        guard let item = item else {return}
        let imageUrl = URL(string: item.imageLinks[0])
        itemImageView.sd_setImage(with: imageUrl)
    }
}


