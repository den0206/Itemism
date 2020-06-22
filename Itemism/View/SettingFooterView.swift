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
    
    private lazy var logoutButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log Out", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let line = UIView()
        line.backgroundColor = .systemGroupedBackground
        
        addSubview(line)
        line.anchor(top: topAnchor,left : leftAnchor,right: rightAnchor, width: frame.width, height: 32)
        
        addSubview(logoutButton)
        logoutButton.anchor(top : line.bottomAnchor,left: leftAnchor,right: rightAnchor,height: 50)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Actions
    
    @objc func handleLogout() {
        delegate?.handleLogOut()
    }
}
