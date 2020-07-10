//
//  PopupViewController.swift
//  Itemism
//
//  Created by 酒井ゆうき on 2020/07/09.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit

enum RequestSections : Int, CaseIterable {
    
    case name
    case item
    case message
    
    var description : String  {
        
        switch self {
      
        case .name:
            return "Name"
        case .item:
            return "Item"
        case .message:
            return "Message"
        }
    }
    
}

class RequestPopupController : UIViewController {
    
    var request : Request?
    
    //MARK: - Parts
    
    private let userIMageView : UIImageView = {
        let iv = UIImageView()
        
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .lightGray

        let ivSize : CGFloat = 80

        iv.setDimensions(height: ivSize, width: ivSize)
        iv.layer.cornerRadius = ivSize / 2
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    lazy var requestLabel : UILabel = {
        let label = UILabel()
        label.text = "\(request?.requestUser.name)さんからメッセージが届いています。"
        label.textAlignment = .center
        return label
    }()
    
    lazy var messageTextView : UITextView = {
        let tv = UITextView()
        tv.text = "Messages"
        tv.font = UIFont.systemFont(ofSize: 20)
        tv.backgroundColor = .systemGroupedBackground
        tv.isEditable = false
        tv.isSelectable = false
    
        return tv
    }()
    
    let messageButton : UIButton = {
        let button = UIButton(type: .system)
        
        button.setTitle("Message", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        button.layer.cornerRadius = 13 / 2
        button.clipsToBounds = true
        
        button.addTarget(self, action: #selector(handleMessage), for: .touchUpInside)
        return button
    }()
    
    let cancelButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .red
        button.layer.cornerRadius = 13 / 2
        button.clipsToBounds = true
        
        button.addTarget(self, action: #selector(handleCancel(sender:)), for: .touchUpInside)

        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
       
    }
    
    //MARK: - UI
    
    private func configureUI() {
        view.backgroundColor = .systemGroupedBackground
        
        
        
        view.addSubview(userIMageView)
        userIMageView.centerX(inView: view)
        userIMageView.anchor(top : view.topAnchor, paddingTop: 20)
        
        view.addSubview(requestLabel)
        requestLabel.anchor(top : userIMageView.bottomAnchor,left: view.leftAnchor,right: view.rightAnchor,paddingTop: 16,paddingLeft: 8,paddingRight: 8)
        
        
        borderLine(topView: requestLabel)
        
        view.addSubview(messageTextView)
        messageTextView.anchor(top: requestLabel.bottomAnchor,left: view.leftAnchor,right: view.rightAnchor,paddingTop: 40,paddingLeft: 8,paddingRight: 8)
        messageTextView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        
        borderLine(topView: messageTextView)
        
        let buttonStack = UIStackView(arrangedSubviews: [messageButton,cancelButton])
        buttonStack.axis = .vertical
        buttonStack.spacing = 24
        buttonStack.distribution = .fillEqually
        
        view.addSubview(buttonStack)
        buttonStack.anchor(top: messageTextView.bottomAnchor, left :view.leftAnchor,right: view.rightAnchor, paddingTop: 40,paddingLeft: 40,paddingRight: 40,width: 0,height: 150)
        
       
        
        

    }
    
    //MARK: - Actions
    
    @objc func handleMessage() {
        print("Message")
    }
   
    @objc func handleCancel(sender : UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Helpers
    
    func borderLine(topView : UIView){
        let line = UIView()
        line.backgroundColor = .lightGray
        
        view.addSubview(line)
        line.anchor(top: topView.bottomAnchor, left : view.leftAnchor, right : view.rightAnchor, paddingTop: 20,width: view.frame.width,height: 0.75)
 
      
    }
    
    
}


