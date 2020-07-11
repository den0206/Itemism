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
        let button = UIButton(type: .system)
        button.backgroundColor = .green
        
        button.setTitle("Send Message", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(didTapMessage), for: .touchUpInside)
        return button
    }()
    
    private let cancelButton : UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .red
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
                
        configureBlueView()
        configureUI()
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
    
    private func configureUI() {
        /// alpha is .zero at first
        views.forEach { (view) in
            addSubview(view)
            view.alpha = 0
            
            
        }
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
