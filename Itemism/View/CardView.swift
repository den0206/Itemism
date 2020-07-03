//
//  CardView.swift
//  Itemism
//
//  Created by 酒井ゆうき on 2020/06/28.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit

enum CardViewType {
    case Detail
    case Default
}

enum SwipeDirection : Int{
    case left = -1
    case right = 1
}

protocol CardViewDelegate : class {
    func handleCardView(cardView : CardView, didLike : Bool)
}

class CardView : UIView {
    
    //MARK: - Property
    
    let item : Item
    let type : CardViewType
    var imageIndex = 0
    var imageUrl : URL?
    
    weak var delegate : CardViewDelegate?

    
    //MARK: - Parts
    
    private let gradientLayer = CAGradientLayer()
    private let barStackView = UIStackView()
    
    private let itemImageView : UIImageView = {
        let iv = UIImageView()
//        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    private let  infoLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textColor = .white
        label.text = "Info"
        return label
    }()
    
    
    init(type : CardViewType, item : Item) {
        self.item = item
        self.type = type
        super.init(frame: .zero)
        
        layer.cornerRadius = 10
        clipsToBounds = true
        
        addSubview(itemImageView)
        itemImageView.fillSuperview()
        
        /// bar View
        
        if item.imageLinks.count > 1 {
            configureBarStackView()
        }
        /// add layer & gesture
        configureGradientLayer()
        
        addSubview(infoLabel)
        infoLabel.anchor(left : leftAnchor, bottom: bottomAnchor, right: rightAnchor,paddingLeft: 16,paddingBottom: 16,paddingRight: 16)
        
        
    }
    
    override func layoutSubviews() {
        gradientLayer.frame = self.frame
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    //MARK: - UI
    
    private func configureGradientLayer() {
        configureGestureRecoganizer()
        
        imageUrl = URL(string: item.imageLinks[0])
        itemImageView.sd_setImage(with: imageUrl)
        
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.5, 1,1]
        layer.addSublayer(gradientLayer)
        
    }
    
    private func configureGestureRecoganizer() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleChangePhoto))
        addGestureRecognizer(tap)
        
        
        /// excecude
        if type == .Default {
            let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
            addGestureRecognizer(pan)
        }
    }
    
    private func configureBarStackView() {
        
        (0 ..< item.imageLinks.count).forEach { (_) in
            
            let barView = UIView()
            barView.backgroundColor = UIColor(white: 0, alpha: 0.1)
            
            barStackView.addArrangedSubview(barView)
            
        }
        
        barStackView.arrangedSubviews.first?.backgroundColor = .white
        addSubview(barStackView)
        barStackView.anchor(top : topAnchor,left: leftAnchor,right: rightAnchor,paddingTop: 8,paddingLeft: 8,paddingRight: 8,height: 4)
        barStackView.spacing = 4
        barStackView.distribution = .fillEqually
               
    }
    
    //MARK: - Actions
    
    @objc func handleChangePhoto(sender : UITapGestureRecognizer) {
        
        let location = sender.location(in: nil).x
        let shouldShowNextPhoto = location > self.frame.width / 2
        
        if shouldShowNextPhoto {
            
            guard imageIndex < item.imageLinks.count - 1 else {return}
            
            imageIndex += 1
            imageUrl = URL(string: item.imageLinks[imageIndex])
            
        } else {
            guard imageIndex > 0 else {return}
            
            imageIndex -= 1
            imageUrl = URL(string: item.imageLinks[imageIndex])
        }
        
        itemImageView.sd_setImage(with: imageUrl)
        barStackView.arrangedSubviews.forEach({$0.backgroundColor = UIColor(white: 0, alpha: 0.1)})
        barStackView.arrangedSubviews[imageIndex].backgroundColor = .white
        
    }
    
    @objc func handlePanGesture(sender : UIPanGestureRecognizer) {
        
        // TODO: - edit Pan Gesture
        
        switch sender.state {
        
        case .began:
            superview?.subviews.forEach({ (view) in
                view.layer.removeAllAnimations()
            })
            
        case .changed:
            panCard(sender: sender)
        case .ended:
            resetCardPosition(sender: sender)
       
        default:
            break
        }
    }
    
    private func panCard(sender : UIPanGestureRecognizer) {
        
        let transration = sender.translation(in: nil)
        
        let degrees : CGFloat = transration.x / 20
        let angle = degrees * .pi / 180
        let rotaionalTrabsform = CGAffineTransform(rotationAngle: angle)
        
        self.transform = rotaionalTrabsform.translatedBy(x: transration.x, y: transration.y)
    }
    
    private func resetCardPosition(sender : UIPanGestureRecognizer) {
        
        let direction : SwipeDirection = sender.translation(in: nil).x > 100 ? .right : .left
        let showldDismissCard = abs(sender.translation(in: nil).x) > 150
        
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
            
            if showldDismissCard {
                
                let xTranslation = CGFloat(direction.rawValue) * 1000
                let ofScreenTransform = self.transform.translatedBy(x: xTranslation, y: 0)
                self.transform = ofScreenTransform
            } else {
                self.transform = .identity
            }
        }) { (_) in
            
            /// add Like
            if showldDismissCard {
                let didlike = direction == .right
                self.delegate?.handleCardView(cardView: self, didLike: didlike)
            }
        }
    }
    
    
}
