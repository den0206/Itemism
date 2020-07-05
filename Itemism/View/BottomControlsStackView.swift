//
//  BottomControlsStackView.swift
//  Itemism
//
//  Created by 酒井ゆうき on 2020/06/28.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit

protocol BottomControlsStackViewDelegate : class{
    
    func handleEdit()
    func handleDelete()
    
    func handleFavorite()
    func handleUnfavorite()
}

/// optoonal
extension BottomControlsStackViewDelegate {
    func handleEdit() {}
    func handleDelete() {}
    
    func handleFavorite() {}
    func handleUnfavorite() {}
}

class BottomControlsStackView : UIStackView {
    
    let type : UserType
    var delegate : BottomControlsStackViewDelegate?
    
    //MARK: - Parts
    
    let editButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "pencil.circle")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleEdit), for: .touchUpInside)
   
        return button
    }()
    
    let deleteButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "dustbox").withRenderingMode(.alwaysTemplate), for: .normal)
        
        button.imageView?.setDimensions(height: 30, width: 30)
        button.addTarget(self, action: #selector(handleDelete), for: .touchUpInside)
        button.tintColor = .red
        return button
    }()
    
    
    
    let dislikeButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "dismiss_circle").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleUnfavorite), for: .touchUpInside)
      
        
        return button
    }()
    
    let likeButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "super_like_circle").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleFavorite), for: .touchUpInside)
        return button
    }()
    
    init(type : UserType) {
        self.type = type
        super.init(frame: .zero)
        
        
        heightAnchor.constraint(equalToConstant: 100).isActive = true
          distribution = .fillEqually
        
        
        switch type {
            
        case .current:
            [deleteButton, editButton].forEach { (button) in
                addArrangedSubview(button)
            }
        case .another:
            [dislikeButton, likeButton].forEach { (button) in
                addArrangedSubview(button)
            }
        }
        
        
    }
    
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Actions
    
    @objc func handleEdit() {
        delegate?.handleEdit()
    }
    @objc func handleDelete() {
        delegate?.handleDelete()
    }
    
    @objc func handleFavorite() {
        delegate?.handleFavorite()
    }
    
    @objc func handleUnfavorite() {
        delegate?.handleUnfavorite()
    }
    
    
    
}
