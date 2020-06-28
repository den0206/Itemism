//
//  CardView.swift
//  Itemism
//
//  Created by 酒井ゆうき on 2020/06/28.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit

class CardView : UIView {
    
    //MARK: - Property
    
    let item : Item
    
    //MARK: - Parts
    
    private let gradientLayer = CAGradientLayer()
    
    private let itemImageView : UIImageView = {
        
        let iv = UIImageView()
//        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    private let  infoLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textColor = .white
        label.text = "Info"
        return label
    }()
    
    
    init(item : Item) {
        self.item = item
        super.init(frame: .zero)
        
        layer.cornerRadius = 10
        clipsToBounds = true
        
        addSubview(itemImageView)
        itemImageView.fillSuperview()
        
        /// add layer & gesture
        configureGradientLayer()
        
        addSubview(infoLabel)
        infoLabel.anchor(left : leftAnchor, bottom: bottomAnchor, right: rightAnchor,paddingLeft: 16,paddingBottom: 16,paddingRight: 16)
        
        
    }
    
    override func layoutSubviews() {
        gradientLayer.frame = self.frame
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Actions
    
    @objc func handleChangePhoto(sender : UITapGestureRecognizer) {
        
       
        
    }
    
    //MARK: - Helpers
    
    private func configureGradientLayer() {
        configureGestureRecoganizer()
        
        let imageUrl = URL(string: item.imageLinks[0])
        itemImageView.sd_setImage(with: imageUrl)
        
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.5, 1,1]
        layer.addSublayer(gradientLayer)
        
    }
    
    private func configureGestureRecoganizer() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleChangePhoto))
        addGestureRecognizer(tap)
    }
    
    
}
