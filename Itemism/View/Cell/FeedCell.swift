//
//  FeedCell.swift
//  Itemism
//
//  Created by 酒井ゆうき on 2020/06/20.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit
import SDWebImage

protocol FeedCellDelegate : class {
    func tappedUserImage(feedCell : FeedCell, user : User)
}

class FeedCell : UICollectionViewCell {
    
    var delegate : FeedCellDelegate?
    
    var item : Item? {
        didSet {
            configure()
        }
    }
    
    //MARK: - Parts
    
    /// for cell gradient Layer
    private lazy var gradientLayer : CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradient.locations = [0.5,1.1]
        gradient.frame =  CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        return gradient
    }()
    
    private let itemImageView : UIImageView = {
        
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    private lazy var userImageView : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.setDimensions(height: 38, width: 38)
        iv.backgroundColor = .lightGray
        iv.clipsToBounds = true
        iv.layer.cornerRadius =  38 / 2
        iv.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tappedUserImage))
        iv.addGestureRecognizer(tap)
        return iv
    }()
    
    private let  infoLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textColor = .white
        label.text = "Info"
        return label
    }()
    
    private lazy var infoButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "info_icon").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleInfo), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemGroupedBackground
        layer.cornerRadius = 10
        layer.masksToBounds = false
        clipsToBounds = true
        
        addSubview(itemImageView)
        itemImageView.fillSuperview()
        
        
       

        addSubview(infoLabel)
        infoLabel.anchor(left : leftAnchor, bottom: bottomAnchor,right: rightAnchor,paddingLeft: 16,paddingBottom: 32,paddingRight: 16)
        
        addSubview(infoButton)
        infoButton.centerY(inView: infoLabel)
        infoButton.setDimensions(height: 40, width: 40)
        infoButton.anchor(right : rightAnchor,paddingRight: 16)
        
        addSubview(userImageView)
        userImageView.centerY(inView: infoLabel)
        userImageView.anchor(left : infoLabel.rightAnchor,right: infoButton.leftAnchor,paddingLeft: 16,paddingRight: 16 )
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Action
    
    @objc func handleInfo() {
        print("Info")
    }
    
    @objc func tappedUserImage() {
        guard let user = item?.user else {return}
        delegate?.tappedUserImage(feedCell: self, user: user)
    }
    
    private func configure() {
        
        guard let item = item else {return}
        let imageUrl = URL(string: item.imageLinks[0])
        
        itemImageView.sd_setImage(with: imageUrl)
        
        itemImageView.layer.addSublayer(gradientLayer)
        
        infoLabel.text = item.name
        
        guard let imageData = item.user?.profileImageData else {return}
        userImageView.image = downloadImageFromData(picturedata: imageData)
        
        
        
    }

}
