//
//  LoginViewController.swift
//  Itemism
//
//  Created by 酒井ゆうき on 2020/06/20.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit

class LoginViewController : UIViewController  {
    
    //MARK: - Parts
    private let titleLabel : UILabel = {
        let label = UILabel()
        label.text = "Login"
        label.font = UIFont(name: "Avenir-Light", size: 36)
        label.textColor = .black
        return label
    }()
    
    private lazy var emailContainerView : UIView = {
        return inputContainerView(withImage: UIImage(systemName: "envelope")!, textField: emailTextField)
    }()
    
    private lazy var emailTextField : UITextField = {
        return createTextField(withPlaceholder: "Email", isSecureType: false)
    }()
    
    private lazy var passwordContainerView : UIView = {
        let image = #imageLiteral(resourceName: "ic_lock_outline_white_2x").withRenderingMode(.alwaysTemplate)
        image.withTintColor(UIColor.lightGray)
        return inputContainerView(withImage: image, textField: passwordTextField)
    }()
    
    private lazy var passwordTextField : UITextField = {

        return createTextField(withPlaceholder: "Password", isSecureType: true)

    }()
    
    
    
    //MARK: - Liffe cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    //MARK: - configure UI
    
    private func configureUI() {
        
        view.backgroundColor = .systemGroupedBackground
        
        view.addSubview(titleLabel)
        titleLabel.anchor(top : view.safeAreaLayoutGuide.topAnchor)
        titleLabel.centerX(inView: view)
        
        let stack = UIStackView(arrangedSubviews: [emailContainerView,passwordContainerView])
        stack.axis = .vertical
        stack.distribution = .fillEqually
        
        stack.spacing = 24
        
        view.addSubview(stack)
        stack.centerY(inView: view)
        stack.anchor(left : view.leftAnchor, right: view.rightAnchor,paddingTop: 40,paddingLeft: 16,paddingRight: 16)
        
        
    }
}
