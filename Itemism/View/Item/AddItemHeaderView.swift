//
//  AddItemHeaderView.swift
//  Itemism
//
//  Created by 酒井ゆうき on 2020/06/23.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit
import SDWebImage

protocol AddItemHeaderViewDelegate : class {
    func selectedPhoto(_ header : AddItemHeaderView, didSelect : Int)
}

class AddItemHeaderView : UIView {
    
    /// for edit
    var item : Item? {
        didSet {
            loadItem()
        }
    }
    
    
    weak var delegate : AddItemHeaderViewDelegate?
    
    //MARK: - parts
    
    var buttons = [UIButton]()
    
    
    lazy var button1 = createButton(0)
    lazy var button2 = createButton(1)
    lazy var button3 = createButton(2)
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
          backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        buttons = [button1,button2,button3]
        
        addSubview(button1)
        button1.anchor(top : topAnchor, left :leftAnchor,bottom: bottomAnchor,paddingTop: 16,paddingLeft: 16,paddingBottom: 16)
        
        button1.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.45).isActive = true
        
        let stack = UIStackView(arrangedSubviews: [button2,button3])
        
        
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 16
        
        addSubview(stack)
        
        stack.anchor(top : topAnchor,left:  button1.rightAnchor,bottom: bottomAnchor,right: rightAnchor,paddingTop: 16,paddingLeft: 16, paddingBottom: 16,paddingRight: 16)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    private func createButton(_ index : Int) -> UIButton {
        
        let button = UIButton(type: .system)
        button.setTitle("Photo", for: .normal)
        button.setTitleColor(UIColor.lightGray, for: .normal)
        button.layer.cornerRadius = 10
        
        button.clipsToBounds = true
        button.backgroundColor = .white
        button.imageView?.contentMode = .scaleToFill
        button.addTarget(self, action: #selector(selectedPhoto), for: .touchUpInside)
        button.tag = index
        button.isEnabled = false
        
        return button
    }
    
    func loadItem() {
        guard let item = item else {return}
        let imageUrls = item.imageLinks.map({URL(string: $0)})
        
        for(index, url) in imageUrls.enumerated() {
            SDWebImageManager.shared.loadImage(with: url, options: .continueInBackground, progress: nil) { (image, _, _, _, _, _) in
                self.buttons[index].setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
            }
        }
    }
    
    //MARK: - Actions
    
    @objc func selectedPhoto(sender : UIButton) {
        delegate?.selectedPhoto(self, didSelect: sender.tag)
    }
}
