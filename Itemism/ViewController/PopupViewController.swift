//
//  PopupViewController.swift
//  Itemism
//
//  Created by 酒井ゆうき on 2020/07/09.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit

class PopupViewController : UIViewController {
    
    let request : Request
    
    //MARK: - Parts
    
    let popView : UIView = {
        let view = UIView()
        view.backgroundColor = .systemGroupedBackground
        return view
    }()
    
    init(request : Request) {
        self.request = request
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurePopup()
        print(request.requestUser.name)
        
        
    }
    
    //MARK: - UI
    
    private func configurePopup() {
        
        
        let screenWidth : CGFloat = view.frame.width
        let screenHeight : CGFloat = view.frame.height
        
        view.backgroundColor = UIColor(white: 0, alpha: 0.6)
        view.tag = 1
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tappedBackGround))
        self.view.addGestureRecognizer(tap)
        
        popView.frame = CGRect(x: screenWidth / 8, y: screenHeight / 5, width: 300, height: 400)
        
        self.view.addSubview(popView)
        
    }
    
    //MARK: - Actions
    
    @objc func tappedBackGround() {
        print("Back")
        self.view.removeFromSuperview()
    }
}
