//
//  CardView.swift
//  Itemism
//
//  Created by 酒井ゆうき on 2020/06/28.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit

class CardView : UIView {
    
    //MARK: - Parts
    
    private lazy var gradientLayer : CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradient.locations = [0.5,1.1]
        gradient.frame =  CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        return gradient
    }()
    
    private let itemImageView : UIImageView = {
        
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    private let  infoLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textColor = .white
        label.text = "Info"
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
