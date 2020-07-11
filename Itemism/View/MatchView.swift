//
//  MatchView.swift
//  Itemism
//
//  Created by 酒井ゆうき on 2020/07/11.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit

class MatchView : UIView {
    
    let viewModel : MatchViewModel
    
    //MARK: - Parts
    
    let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    
    private let matchImageView : UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "itsamatch")
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    private lazy var descriptonLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20)
        label.numberOfLines = 0
        return label
    }()
    
    private let currentUserImageView : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.borderColor = UIColor.white.cgColor
        iv.setDimensions(height: 140, width: 140)
        iv.layer.cornerRadius = 140 / 2
        iv.layer.borderWidth = 2
        return iv
    }()
    
    private let matchUserImageView : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.borderColor = UIColor.white.cgColor
        iv.setDimensions(height: 140, width: 140)
        iv.layer.cornerRadius = 140 / 2
        iv.layer.borderWidth = 2
        return iv
    }()
    
    private let sendMessageButton : UIButton = {
        let button = GradientButton(leftColor: .green, rightColor: #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1))
//        button.backgroundColor = .green
        button.setTitle("Send Message", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(didTapMessage), for: .touchUpInside)
        return button
    }()
    
    private let cancelButton : UIButton = {
        let button = GradientButton(leftColor: #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1), rightColor: #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1))
//        button.backgroundColor = .red
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()
    
    /// sumVIews
    lazy var views = [
        matchImageView,descriptonLabel,currentUserImageView,matchUserImageView,sendMessageButton,cancelButton
    ]
    
    
    
    //MARK: - Initializer
    
    init(viewModel : MatchViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        
        loadUserData()
                
        configureBlueView()
        configureUI()
        configureAnimations()
    }
    

//
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI
    
    private func configureBlueView() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleDismiss))
        visualEffectView.addGestureRecognizer(tap)
        
        addSubview(visualEffectView)
        visualEffectView.fillSuperview()
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.visualEffectView.alpha = 1
        }, completion: nil)
    }
    
    private func loadUserData() {
        self.descriptonLabel.text = viewModel.matchLabelText
        
        self.currentUserImageView.image = viewModel.currentUserImage
        self.matchUserImageView.image = viewModel.matchUserImage
    }
    
    private func configureUI() {
        /// alpha is .zero at first
        views.forEach { (view) in
            addSubview(view)
            view.alpha = 0
        }
        
        currentUserImageView.anchor(right : centerXAnchor, paddingRight:  16)
        currentUserImageView.centerY(inView: self)
        matchUserImageView.anchor(left : centerXAnchor, paddingLeft:  16)
        matchUserImageView.centerY(inView: self)
        
        sendMessageButton.anchor(top : currentUserImageView.bottomAnchor,left: leftAnchor,right: rightAnchor,paddingTop: 32,paddingLeft: 48,paddingRight: 48)
        sendMessageButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        cancelButton.anchor(top : sendMessageButton.bottomAnchor,left: leftAnchor,right: rightAnchor,paddingTop: 16,paddingLeft: 48,paddingRight: 48)
        cancelButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        descriptonLabel.anchor(left : leftAnchor,bottom: currentUserImageView.topAnchor, right: rightAnchor,paddingBottom: 32)
        
        matchImageView.anchor(bottom :descriptonLabel.topAnchor,paddingBottom: 16)
        matchImageView.setDimensions(height: 80, width: 300)
        matchImageView.centerX(inView: self)
        
    }
    
    private func configureAnimations() {
        views.forEach { (view) in
            view.alpha = 1
        }
        
        let angle = 30 * CGFloat.pi / 180
        
        currentUserImageView.transform = CGAffineTransform(rotationAngle: -angle).concatenating(CGAffineTransform(translationX: 200, y: 0))
        matchUserImageView.transform = CGAffineTransform(rotationAngle: angle).concatenating(CGAffineTransform(translationX: -200, y: 0))
        
        
        sendMessageButton.transform = CGAffineTransform(translationX: -500, y: 0)
        cancelButton.transform = CGAffineTransform(translationX: 500, y: 0)

        UIView.animateKeyframes(withDuration: 1.3, delay: 0, options: .calculationModeCubic, animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.45) {
                
                self.currentUserImageView.transform = CGAffineTransform(rotationAngle: -angle)
                self.matchUserImageView.transform = CGAffineTransform(rotationAngle: -angle)
            }
            
            UIView.addKeyframe(withRelativeStartTime: 0.6, relativeDuration: 0.4) {
                
                self.currentUserImageView.transform = .identity
                self.matchUserImageView.transform = .identity
            }
        }, completion: nil)
        
        UIView.animate(withDuration: 0.75, delay: 0.6 * 1.3, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
            self.sendMessageButton.transform = .identity
            self.cancelButton.transform = .identity
        }, completion: nil)
    }
    
    //MARK: - Actions
    
    @objc func didTapMessage() {
        print("Message")
    }
    

    
    @objc func handleDismiss() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.alpha = 0
        }) { (_) in
            self.removeFromSuperview()
        }
    }
}
