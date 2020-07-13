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
    
    
    private let loginButton : UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .lightGray
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        
        return button
    }()
    
    private let alertLabel : UILabel  = {
        let label = UILabel()
        
        label.text = "※項目を埋めてください"
        label.textColor = .red
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()
    
    let dontHaveAccountButton : UIButton = {
        let button = UIButton(type: .system)
        
        let attributeTitle = NSMutableAttributedString(string: "アカウントを持っていませんか?", attributes: [NSAttributedString.Key.foregroundColor : UIColor.black])
        
        attributeTitle.append(NSMutableAttributedString(string: " Sign Up", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray]))
        
        button.setAttributedTitle(attributeTitle, for: .normal)
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return button
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
        
        let stack = UIStackView(arrangedSubviews: [emailContainerView,passwordContainerView, loginButton, alertLabel])
        stack.axis = .vertical
        stack.distribution = .fillEqually
        
        stack.spacing = 24
        
        view.addSubview(stack)
        stack.centerY(inView: view)
        stack.anchor(left : view.leftAnchor, right: view.rightAnchor,paddingTop: 40,paddingLeft: 16,paddingRight: 16)
        
        
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.centerX(inView: view)
        dontHaveAccountButton.anchor(bottom : view.safeAreaLayoutGuide.bottomAnchor, paddingBottom:  12)
        
        addTFValidation()
    }
    
    private func addTFValidation() {
        
        for tf in [emailTextField,passwordTextField] {
            tf.addTarget(self, action: #selector(fillTextField), for: .editingChanged)
            tf.delegate = self
        }

    }
    
    //MARK: - Actions
    
    @objc func handleSignUp() {
        let signVC = SignUpViewController()
        
        navigationController?.pushViewController(signVC, animated: true)
    }
    
    @objc func handleLogin() {
        guard let email = emailTextField.text , let password = passwordTextField.text else {
            showAlert(title: "Recheck", message: "項目を埋めてください")
            
            return
        }
        
        guard isValidEmail(email) else {
            showAlert(title: "Recheck", message: "Eメール用の書式を記入ください")
            return
        }
        
        checkInternetConnection()
        
        showPresentLoadindView(true)
        
        AuthService.loginUser(email: email, password: password) { (result, error) in
            
            if error != nil {
                self.showAlert(title: "Recheck", message: error!.localizedDescription)
                self.showPresentLoadindView(false)
                return
            }
            
            /// no error
            
            guard let window = UIApplication.shared.windows.first(where: {$0.isKeyWindow}) else {return}
            guard let tab = window.rootViewController as? MainTabController else {return}
            
            tab.checkUserIsLogin()
            
            self.dismiss(animated: true) {
                // dismiss Indicator
                self.showPresentLoadindView(false)
            }
            
            
        }
    }
    
    @objc func fillTextField() {
        
        guard emailTextField.text != "" && passwordTextField.text != "" else {
            alertLabel.isHidden = false
            
            loginButton.isEnabled = false
            loginButton.backgroundColor = .lightGray
            return
        }
        
        alertLabel.isHidden = true
        
        loginButton.isEnabled = true
        loginButton.backgroundColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
    }
}


extension LoginViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
