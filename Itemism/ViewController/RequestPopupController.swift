//
//  PopupViewController.swift
//  Itemism
//
//  Created by 酒井ゆうき on 2020/07/09.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit


protocol RequestPopupControllerDelegate : class {
    func handleMatching(popup : RequestPopupController, matchedUser : User )
}
class RequestPopupController : UIViewController {
    
    var request : Request?
    weak var delegate : RequestPopupControllerDelegate?
    
    //MARK: - Parts
    
    var headerView : UIView = {
        let view = UIView()
//        view.backgroundColor = .red
        return view
    }()
    
    
    private let userIMageView : UIImageView = {
        let iv = UIImageView()
        
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .lightGray

        let ivSize : CGFloat = 40

        iv.setDimensions(height: ivSize, width: ivSize)
        iv.layer.cornerRadius = ivSize / 2
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    lazy var requestLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        return label
    }()
    
    lazy var messageTextView : UITextView = {
        let tv = UITextView()
        tv.text = "Messagesfdfdafdafdafddfddfdfmkdfdfdfdfsdfsdfdfafdsafs"
        tv.font = UIFont.systemFont(ofSize: 20)
        tv.backgroundColor = .systemGroupedBackground
        tv.isEditable = false
        tv.isSelectable = false
    
        return tv
    }()
    
    let matchingButton : UIButton = {
        let button = GradientButton(leftColor: .green, rightColor: #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1))
        button.setTitle("Matching!", for: .normal)
        button.setTitleColor(.white, for: .normal)
//        button.layer.cornerRadius = 13 / 2
//        button.clipsToBounds = true
        
        button.addTarget(self, action: #selector(handleMatching), for: .touchUpInside)
        return button
    }()
    
    let cancelButton : UIButton = {
        let button = GradientButton(leftColor: #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1), rightColor: #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1))
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .red
//        button.layer.cornerRadius = 13 / 2
//        button.clipsToBounds = true
        
        button.addTarget(self, action: #selector(handleCancel(sender:)), for: .touchUpInside)

        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        loadRequest()
       
    }
    
    //MARK: - UI
    
    private func configureUI() {
        view.backgroundColor = .systemGroupedBackground
        
        view.addSubview(headerView)
        headerView.anchor(top : view.topAnchor,left : view.leftAnchor,right: view.rightAnchor,width: view.frame.width, height: view.frame.height / 8 * 1)
      
        headerView.addSubview(userIMageView)
        userIMageView.centerX(inView: headerView)
        userIMageView.anchor(top : headerView.topAnchor, paddingTop: 20)

        headerView.addSubview(requestLabel)
        requestLabel.anchor(top : userIMageView.bottomAnchor,left: view.leftAnchor,right: view.rightAnchor,paddingTop: 16,paddingLeft: 8,paddingRight: 8)


        borderLine(topView: headerView)

        view.addSubview(messageTextView)
        messageTextView.anchor(top: headerView.bottomAnchor,left: view.leftAnchor,right: view.rightAnchor,paddingTop: 40,paddingLeft: 8,paddingRight: 8)
        messageTextView.heightAnchor.constraint(equalToConstant: (view.frame.height / 8) * 3).isActive = true

        borderLine(topView: messageTextView)

        let buttonStack = UIStackView(arrangedSubviews: [cancelButton,matchingButton])
        buttonStack.axis = .horizontal
        buttonStack.spacing = 24
        buttonStack.distribution = .fillEqually

        view.addSubview(buttonStack)
        buttonStack.anchor(top: messageTextView.bottomAnchor, left :view.leftAnchor, bottom : view.bottomAnchor, right: view.rightAnchor,paddingTop: 40, paddingLeft: 40, paddingBottom: 20, paddingRight: 40,width: view.frame.width,height: 60)

       
        
        

    }
    
    
    
    //MARK: - Actions
    
    @objc func handleMatching() {
        checkInternetConnection()
        
        guard let user = request?.requestUser else {return}
        delegate?.handleMatching(popup: self, matchedUser: user)
    }
    
    @objc func handleCancel(sender : UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Helpers
    
    func loadRequest() {
        
        guard let request = request else {return}
        
        let requestUser = request.requestUser
        let userImage = downloadImageFromData(picturedata: requestUser.profileImageData)
        userIMageView.image = userImage
        requestLabel.text = "\(requestUser.name)さんからメッセージが届いています。"
        
        
        
    }
    
    func borderLine(topView : UIView){
        let line = UIView()
        line.backgroundColor = .lightGray
        
        view.addSubview(line)
        line.anchor(top: topView.bottomAnchor, left : view.leftAnchor, right : view.rightAnchor, paddingTop: 20,width: view.frame.width,height: 0.75)
 
      
    }
    
    
}


