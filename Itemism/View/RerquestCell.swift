//
//  RerquestCell.swift
//  Itemism
//
//  Created by 酒井ゆうき on 2020/07/09.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit

class RerquestCell : UITableViewCell {
    
    //MARK: - Parts
    
   
    
    private let userImageView : UIImageView = {
        let iv = UIImageView()
        iv.setDimensions(height: 30, width: 30)
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .lightGray
        iv.layer.cornerRadius = 30 / 2
        iv.clipsToBounds = true
        return iv
        
    }()
    
    private let middleText : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = " さんから"
        return label
    }()
    
    private let itemImageView : UIImageView = {
        let iv = UIImageView()
        iv.setDimensions(height: 30, width: 30)
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .lightGray
        iv.layer.cornerRadius = 30 / 2
        iv.clipsToBounds = true
        return iv
        
    }()
    
    private let lastLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = " へのリクエスト"
//        label.numberOfLines = 2
        return label
    }()
    
    private lazy var accceptButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("承認する", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 13 / 2
        button.backgroundColor = .lightGray
        
        button.addTarget(self, action: #selector(handleAccept), for: .touchUpInside)
        return button
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .systemGroupedBackground
        
        addSubview(accceptButton)
        accceptButton.centerY(inView: self)
        accceptButton.anchor(right : rightAnchor,paddingRight: 16, width: 92,height: 32)
        
        let stack = UIStackView(arrangedSubviews: [userImageView,middleText, itemImageView,lastLabel])
        stack.spacing = 8
        stack.alignment = .center
        
        addSubview(stack)
        stack.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 12)
//        stack.anchor(right : accceptButton.leftAnchor, paddingRight: 8)

        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Actions
    
    @objc func handleAccept() {
        print("Accept")
    }
}
