//
//  SignUpViewController.swift
//  Itemism
//
//  Created by 酒井ゆうき on 2020/06/21.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit

class SignUpViewController : UIViewController {
    
    /// Selected Image
    private var selectedImage : UIImage?
    private let imagePicker = UIImagePickerController()
    
    //MARK: - Parts
    
    private let titleLabel : UILabel = {
        let label = UILabel()
        label.text = "Sign Up"
        label.font = UIFont(name: "Avenir-Light", size: 36)
        label.textColor = .black
        return label
    }()
    
    /// fields
    
    private let plusPhotoButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "plus_photo"), for: .normal)
        button.tintColor = .lightGray
        button.setDimensions(height: 150, width: 150)
        button.addTarget(self, action: #selector(tappedPlusButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var emailContainerView : UIView = {
        return inputContainerView(withImage: UIImage(systemName: "envelope")!, textField: emailTextField)
    }()
    
    private lazy var emailTextField : UITextField = {
        return createTextField(withPlaceholder: "Email", isSecureType: false)
    }()
    
    private lazy var fullnameContainerView : UIView = {
        
        let image = #imageLiteral(resourceName: "ic_person_outline_white_2x").withRenderingMode(.alwaysTemplate)
        image.withTintColor(UIColor.lightGray)
        return inputContainerView(withImage: image, textField: fullnameTextField)
    }()
    
    private lazy var fullnameTextField : UITextField = {
        
        return createTextField(withPlaceholder: "Fullname", isSecureType: false)
    }()
    
    private lazy var passwordContainerView : UIView = {
        let image = #imageLiteral(resourceName: "ic_lock_outline_white_2x").withRenderingMode(.alwaysTemplate)
        image.withTintColor(UIColor.lightGray)
        return inputContainerView(withImage: image, textField: passwordTextField)
    }()
    
    private lazy var passwordTextField : UITextField = {

        return createTextField(withPlaceholder: "Password", isSecureType: true)

    }()
    
    private lazy var passwordConfirmationContainerView : UIView = {
          let image = #imageLiteral(resourceName: "ic_lock_outline_white_2x").withRenderingMode(.alwaysTemplate)
          image.withTintColor(UIColor.lightGray)
          return inputContainerView(withImage: image, textField: passwordConfirmationTextField)
      }()
      
      private lazy var passwordConfirmationTextField : UITextField = {

          return createTextField(withPlaceholder: "Password Confirmation", isSecureType: true)

      }()
    
    ///
    
    private let SignUpButton : UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .lightGray
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        
        return button
    }()
    
    private let alertLabel : UILabel = {
        
        let label = UILabel()
        label.text = "※項目を埋めてください"
        label.textColor = .red
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()
    
    let alreadyHaveAccountButton : UIButton = {
        let button = UIButton(type: .system)
        
        let attributeTitle = NSMutableAttributedString(string: "アカウントを既に持っていますか?", attributes: [NSAttributedString.Key.foregroundColor : UIColor.black])
        
        attributeTitle.append(NSMutableAttributedString(string: " Log In", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray]))
        
        button.setAttributedTitle(attributeTitle, for: .normal)
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
    }
    
    //MARK: - config UI
    
    private func configureUI() {
        
        view.backgroundColor = .systemGroupedBackground
        
        view.addSubview(titleLabel)
        titleLabel.anchor(top : view.safeAreaLayoutGuide.topAnchor)
        titleLabel.centerX(inView: view)
        
        view.addSubview(plusPhotoButton)
        view.addSubview(plusPhotoButton)
        plusPhotoButton.centerX(inView: view, topAnchor: titleLabel.bottomAnchor, paddingTop: 16)
        
        
        
        let stack = UIStackView(arrangedSubviews: [emailContainerView, fullnameContainerView, passwordContainerView,passwordConfirmationContainerView, SignUpButton,alertLabel])
        
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 24
        
        view.addSubview(stack)
//        stack.centerY(inView: view, constant: 40)
        stack.anchor(top : plusPhotoButton.bottomAnchor, left : view.leftAnchor, right: view.rightAnchor,paddingTop: 20,paddingLeft: 16,paddingRight: 16)
        
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.centerX(inView: view)
        alreadyHaveAccountButton.anchor(bottom : view.safeAreaLayoutGuide.bottomAnchor, paddingBottom:  12)
        
        [emailTextField, fullnameTextField,passwordTextField,passwordConfirmationTextField].forEach { (tf) in
            tf.addTarget(self, action: #selector(fillTextField), for: .editingChanged)
            tf.delegate = self
        }
        
    }
    
    //MARK: - Actions
    @objc func handleLogin() {
        navigationController?.popViewController(animated: true)
    }
    
    
    @objc func fillTextField() {
        guard emailTextField.text != "" && fullnameTextField.text != "" && passwordTextField.text != "" && passwordConfirmationTextField.text != "" else {
            alertLabel.isHidden = false
            
            SignUpButton.isEnabled = false
            SignUpButton.backgroundColor = .lightGray
            return
        }
        
        alertLabel.isHidden = true
        
        SignUpButton.isEnabled = true
        SignUpButton.backgroundColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
    }
    
    
    @objc func tappedPlusButton() {
       
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    @objc func handleSignUp() {
        
        /// validations
        guard selectedImage != nil else {
            showAlert(title: "Recheck", message: "画像を選択してください")
            return
        }
        
        guard isValidEmail(emailTextField.text!) else {
            showAlert(title: "Recheck", message: "Eメール用の書式を記入ください")
            return
        }
        
        guard passwordTextField.text == passwordConfirmationTextField.text else {
            showAlert(title: "Recheck", message: "確認用パスワードが一致しません")
            return
        }
        
        checkInternetConnection()
        
        let avatarData = selectedImage?.jpegData(compressionQuality: 0.3)
        let avatar = avatarData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        
        showPresentLoadindView(true)
        
        let credential = AuthCredential(email: emailTextField.text!, fullname: fullnameTextField.text!, password: passwordTextField.text!, profileImage: avatar!)
        
        AuthService.registerser(credential: credential) { (error) in
            
            if error != nil {
                self.showPresentLoadindView(false)
                self.showAlert(title: "error", message: error!.localizedDescription)
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
    
    
}

extension SignUpViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension SignUpViewController : UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let profileImage = info[.editedImage] as? UIImage else {return}
        self.selectedImage = profileImage
        
        plusPhotoButton.layer.cornerRadius = 150 / 2
        plusPhotoButton.layer.masksToBounds = true
        plusPhotoButton.imageView?.contentMode = .scaleAspectFill
        plusPhotoButton.imageView?.clipsToBounds = true
        plusPhotoButton.layer.borderColor = UIColor.lightGray.cgColor
        plusPhotoButton.layer.borderWidth = 2
        
        plusPhotoButton.setImage(profileImage.withRenderingMode(.alwaysOriginal), for: .normal)
        self.dismiss(animated: true, completion: nil)
        
    }
}
