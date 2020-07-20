//
//  SettingFooterView.swift
//  Itemism
//
//  Created by 酒井ゆうき on 2020/06/22.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit

protocol SettingFooterViewDelegate : class {
    
    func handleLogOut()
}

class SettingFooterView : UIView {
    
    weak var delegate : SettingFooterViewDelegate?
    
    
    let saveButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .blue
        button.addTarget(self, action: #selector(handleSave), for: .touchUpInside)
        button.layer.cornerRadius = 32 / 2
        button.clipsToBounds = true
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return button
    }()
    
    private lazy var logoutButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log Out", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 32 / 2
               button.clipsToBounds = true
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let line = UIView()
        line.backgroundColor = .systemGroupedBackground
        
        addSubview(line)
        line.anchor(top: topAnchor,left : leftAnchor,right: rightAnchor, width: frame.width, height: 32)
        
        let stack = UIStackView(arrangedSubviews: [saveButton, logoutButton])
        stack.axis = .vertical
        stack.spacing = 8
        stack.distribution = .fillEqually

        addSubview(stack)
        stack.anchor(top : line.bottomAnchor,left: leftAnchor,bottom: bottomAnchor,right: rightAnchor, paddingTop: 30,paddingLeft: 40,paddingRight: 40)
        
//        addSubview(logoutButton)
//        logoutButton.anchor(top : line.bottomAnchor,left: leftAnchor,right: rightAnchor,height: 50)
//
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Actions
    
    @objc func handleSave() {
        print("save")
    }
    
    @objc func handleLogout() {
        delegate?.handleLogOut()
    }
}
