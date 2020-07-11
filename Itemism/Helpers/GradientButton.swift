//
//  GradientButton.swift
//  Itemism
//
//  Created by 酒井ゆうき on 2020/07/11.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//


import UIKit

class GradientButton : UIButton {
    
    var leftColor : UIColor
    var rightColor : UIColor
    
    init(leftColor : UIColor, rightColor : UIColor) {
        self.leftColor = leftColor
        self.rightColor = rightColor
        super.init(frame: .zero)

    }


    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.colors = [leftColor.cgColor, rightColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        
        self.layer.insertSublayer(gradientLayer, at: 0)
        
        layer.cornerRadius = rect.height /  2
        clipsToBounds = true
        gradientLayer.frame = rect
    }
}

