//
//  Extensions.swift
//  Itemism
//
//  Created by 酒井ゆうき on 2020/06/20.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//


import UIKit

public struct AnchoredConstraints {
    public var top, leading, bottom, trailing, width, height: NSLayoutConstraint?
}

class GradiatinButton : UIButton {
    override func draw(_ rect: CGRect) {
        super.draw(rect)

        let gradientLayer = CAGradientLayer()
        let leftColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        let rightColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)


        gradientLayer.colors = [leftColor.cgColor, rightColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)

        self.layer.insertSublayer(gradientLayer, at: 0)

        layer.cornerRadius = rect.height /  2
        clipsToBounds = true
        gradientLayer.frame = rect
    }
}

func isValidEmail(_ string: String) -> Bool {
       let emailRegEx = "[A-Z0-9a-z._+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
       let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
       let result = emailTest.evaluate(with: string)
       return result
}


extension UIViewController {
    func configureGradientLayer() {
        let topColor = #colorLiteral(red: 0.9921568627, green: 0.3568627451, blue: 0.3725490196, alpha: 1)
        let bottomColor = #colorLiteral(red: 0.8980392157, green: 0, blue: 0.4470588235, alpha: 1)
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.locations = [0, 1]
        view.layer.addSublayer(gradientLayer)
        gradientLayer.frame = view.frame
    }
    
    func inputContainerView(withImage : UIImage, textField : UITextField? = nil) -> UIView {
        
        let view = UIView()
        
        let iv = UIImageView()
        iv.image = withImage
        iv.tintColor = .lightGray
        iv.alpha = 0.87
        view.addSubview(iv)
        
        if let textField = textField {
            iv.centerY(inView: view)
            iv.anchor(left : view.leftAnchor, paddingLeft: 8, width: 24, height: 24)
            
            view.addSubview(textField)
            textField.centerY(inView: view)
            textField.anchor(left : iv.rightAnchor, bottom:  view.bottomAnchor, right: view.rightAnchor, paddingLeft: 8, paddingBottom: 8)
        }
        
        let separatorVIew = UIView()
        separatorVIew.backgroundColor = .black
        view.addSubview(separatorVIew)
        separatorVIew.anchor(left : view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingLeft: 8, height: 0.75)
        
        return view
    }
    
    func createTextField(withPlaceholder : String, isSecureType : Bool) -> UITextField {
        let tf = UITextField()
        tf.borderStyle = .none
        tf.font = UIFont.systemFont(ofSize: 16)
        tf.textColor = .black
        tf.keyboardAppearance = .dark
        tf.isSecureTextEntry = isSecureType
        tf.attributedPlaceholder = NSAttributedString(string: withPlaceholder, attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        tf.autocapitalizationType = .none
        
        return tf
        }
}

extension UIView {
    
    func anchor(top: NSLayoutYAxisAnchor? = nil,
                   left: NSLayoutXAxisAnchor? = nil,
                   bottom: NSLayoutYAxisAnchor? = nil,
                   right: NSLayoutXAxisAnchor? = nil,
                   paddingTop: CGFloat = 0,
                   paddingLeft: CGFloat = 0,
                   paddingBottom: CGFloat = 0,
                   paddingRight: CGFloat = 0,
                   width: CGFloat? = nil,
                   height: CGFloat? = nil) {
           
           translatesAutoresizingMaskIntoConstraints = false
           
           if let top = top {
               topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
           }
           
           if let left = left {
               leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
           }
           
           if let bottom = bottom {
               bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
           }
           
           if let right = right {
               rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
           }
           
           if let width = width {
               widthAnchor.constraint(equalToConstant: width).isActive = true
           }
           
           if let height = height {
               heightAnchor.constraint(equalToConstant: height).isActive = true
           }
       }
       
       func centerX(inView view : UIView, topAnchor : NSLayoutYAxisAnchor? = nil, paddingTop : CGFloat? = 0) {
            translatesAutoresizingMaskIntoConstraints = false
            centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            
            if let topAnchor = topAnchor {
                self.topAnchor.constraint(equalTo: topAnchor, constant: paddingTop!).isActive = true
            }
        }
       
       func centerY(inView view: UIView, leftAnchor: NSLayoutXAxisAnchor? = nil,
                    paddingLeft: CGFloat = 0, constant: CGFloat = 0) {
           
           translatesAutoresizingMaskIntoConstraints = false
           centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: constant).isActive = true
           
           if let left = leftAnchor {
               anchor(left: left, paddingLeft: paddingLeft)
           }
       }
    
    func center(inView view : UIView, yConstant : CGFloat? = 0) {
           translatesAutoresizingMaskIntoConstraints = false
           centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
           centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: yConstant!).isActive = true
       }
       
       func setDimensions(height: CGFloat, width: CGFloat) {
           translatesAutoresizingMaskIntoConstraints = false
           heightAnchor.constraint(equalToConstant: height).isActive = true
           widthAnchor.constraint(equalToConstant: width).isActive = true
       }
    
    @discardableResult
    open func anchor(top: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, trailing: NSLayoutXAxisAnchor?, padding: UIEdgeInsets = .zero, size: CGSize = .zero) -> AnchoredConstraints {
        
        translatesAutoresizingMaskIntoConstraints = false
        var anchoredConstraints = AnchoredConstraints()
        
        if let top = top {
            anchoredConstraints.top = topAnchor.constraint(equalTo: top, constant: padding.top)
        }
        
        if let leading = leading {
            anchoredConstraints.leading = leadingAnchor.constraint(equalTo: leading, constant: padding.left)
        }
        
        if let bottom = bottom {
            anchoredConstraints.bottom = bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom)
        }
        
        if let trailing = trailing {
            anchoredConstraints.trailing = trailingAnchor.constraint(equalTo: trailing, constant: -padding.right)
        }
        
        if size.width != 0 {
            anchoredConstraints.width = widthAnchor.constraint(equalToConstant: size.width)
        }
        
        if size.height != 0 {
            anchoredConstraints.height = heightAnchor.constraint(equalToConstant: size.height)
        }
        
        [anchoredConstraints.top, anchoredConstraints.leading, anchoredConstraints.bottom, anchoredConstraints.trailing, anchoredConstraints.width, anchoredConstraints.height].forEach{ $0?.isActive = true }
        
        return anchoredConstraints
    }
    
    @discardableResult
    open func fillSuperview(padding: UIEdgeInsets = .zero) -> AnchoredConstraints {
        translatesAutoresizingMaskIntoConstraints = false
        let anchoredConstraints = AnchoredConstraints()
        guard let superviewTopAnchor = superview?.topAnchor,
            let superviewBottomAnchor = superview?.bottomAnchor,
            let superviewLeadingAnchor = superview?.leadingAnchor,
            let superviewTrailingAnchor = superview?.trailingAnchor else {
                return anchoredConstraints
        }
        
        return anchor(top: superviewTopAnchor, leading: superviewLeadingAnchor, bottom: superviewBottomAnchor, trailing: superviewTrailingAnchor, padding: padding)
    }
    
    @discardableResult
    open func fillSuperviewSafeAreaLayoutGuide(padding: UIEdgeInsets = .zero) -> AnchoredConstraints {
        let anchoredConstraints = AnchoredConstraints()
        if #available(iOS 11.0, *) {
            guard let superviewTopAnchor = superview?.safeAreaLayoutGuide.topAnchor,
                let superviewBottomAnchor = superview?.safeAreaLayoutGuide.bottomAnchor,
                let superviewLeadingAnchor = superview?.safeAreaLayoutGuide.leadingAnchor,
                let superviewTrailingAnchor = superview?.safeAreaLayoutGuide.trailingAnchor else {
                    return anchoredConstraints
            }
            return anchor(top: superviewTopAnchor, leading: superviewLeadingAnchor, bottom: superviewBottomAnchor, trailing: superviewTrailingAnchor, padding: padding)
            
        } else {
            return anchoredConstraints
        }
    }
    
    open func centerInSuperview(size: CGSize = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        if let superviewCenterXAnchor = superview?.centerXAnchor {
            centerXAnchor.constraint(equalTo: superviewCenterXAnchor).isActive = true
        }
        
        if let superviewCenterYAnchor = superview?.centerYAnchor {
            centerYAnchor.constraint(equalTo: superviewCenterYAnchor).isActive = true
        }
        
        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        
        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }
    
    open func centerXToSuperview() {
        translatesAutoresizingMaskIntoConstraints = false
        if let superviewCenterXAnchor = superview?.centerXAnchor {
            centerXAnchor.constraint(equalTo: superviewCenterXAnchor).isActive = true
        }
    }
    
    open func centerYToSuperview() {
        translatesAutoresizingMaskIntoConstraints = false
        if let superviewCenterYAnchor = superview?.centerYAnchor {
            centerYAnchor.constraint(equalTo: superviewCenterYAnchor).isActive = true
        }
    }
    
    @discardableResult
    open func constrainHeight(_ constant: CGFloat) -> AnchoredConstraints {
        translatesAutoresizingMaskIntoConstraints = false
        var anchoredConstraints = AnchoredConstraints()
        anchoredConstraints.height = heightAnchor.constraint(equalToConstant: constant)
        anchoredConstraints.height?.isActive = true
        return anchoredConstraints
    }
    
    @discardableResult
    open func constrainWidth(_ constant: CGFloat) -> AnchoredConstraints {
        translatesAutoresizingMaskIntoConstraints = false
        var anchoredConstraints = AnchoredConstraints()
        anchoredConstraints.width = widthAnchor.constraint(equalToConstant: constant)
        anchoredConstraints.width?.isActive = true
        return anchoredConstraints
    }
    
    open func setupShadow(opacity: Float = 0, radius: CGFloat = 0, offset: CGSize = .zero, color: UIColor = .black) {
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
        layer.shadowOffset = offset
        layer.shadowColor = color.cgColor
    }
    
    convenience public init(backgroundColor: UIColor = .clear) {
        self.init(frame: .zero)
        self.backgroundColor = backgroundColor
    }
}

//MARK: - Indicators

extension UIViewController {
    func showAlert(title : String, message : String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func checkInternetConnection(nav : UINavigationController? = nil, tab : UITabBarController? = nil) {
        
        guard Reachabilty.HasConnection() else {
            showAlert(title: "Error", message: "No Internet Connection")
            
            if nav != nil {
                nav?.showPresentLoadindView(false)
                return
            } else if tab != nil {
                tab?.showPresentLoadindView(false)
                return
            }
            self.showPresentLoadindView(false)
            return
        }
        
        print("connect internt")
        
    }
    
    func showPresentLoadindView(_ present : Bool, message : String? = nil) {
        
        if present {
            
            let blackView = UIView()
            blackView.frame = self.view.bounds
            blackView.backgroundColor = .black
            blackView.alpha = 0
            blackView.tag = 1
            
            let indicator = UIActivityIndicatorView()
            indicator.color = .white
            indicator.style = .large
            indicator.center = blackView.center
            
            let label = UILabel()
            label.text = message
            label.font = UIFont.systemFont(ofSize: 16)
            label.textColor = .white
            label.textAlignment = .center
            label.alpha = 0.7
            
            self.view.addSubview(blackView)
            blackView.addSubview(indicator)
            blackView.addSubview(label)
            
            label.centerX(inView: view)
            label.anchor(top : indicator.bottomAnchor,paddingTop: 23)
            
            indicator.startAnimating()
            
            UIView.animate(withDuration: 0.2) {
                blackView.alpha = 0.7
            }
            
            
        } else {
            
            // hide
            view.subviews.forEach { (subview) in
                
                if subview.tag == 1 {
                    UIView.animate(withDuration: 0.5, animations: {
                        subview.alpha = 0
                    }) { (_) in
                        subview.removeFromSuperview()
                    }
                }
            }
            
        }
    }
}


public struct AttributedString: ExpressibleByStringLiteral, ExpressibleByStringInterpolation, CustomStringConvertible {
    public struct StringInterpolation: StringInterpolationProtocol {
        public var attributedString: NSMutableAttributedString
        public init(literalCapacity: Int, interpolationCount: Int) {
            attributedString = NSMutableAttributedString()
        }

        public func appendLiteral(_ literal: String) {
            attributedString.append(NSAttributedString(string: literal))
        }

        public func appendInterpolation(_ linkText: String? = nil, URL url: URL) {
            let text = linkText ?? url.absoluteString
            attributedString.append(NSAttributedString(string: text, attributes: [.link: url]))
        }

        public func appendInterpolation(_ image: UIImage, bounds: CGRect? = nil) {
            let textAttachment = NSTextAttachment()
            textAttachment.image = image
            if let bounds = bounds {
                textAttachment.bounds = bounds
            }
            attributedString.append(NSAttributedString(attachment: textAttachment))
        }

        func appendInterpolation(_ text: String, attributes: [NSAttributedString.Key: Any]) {
            attributedString.append(NSAttributedString(string: text, attributes: attributes))
        }
    }
    public var attributedString: NSAttributedString
    public init(stringLiteral value: String) {
        attributedString = NSAttributedString(string: value)
    }

    public init(stringInterpolation: StringInterpolation) {
        attributedString = NSAttributedString(attributedString: stringInterpolation.attributedString)
    }

    public init(attributedString: NSAttributedString) {
        self.attributedString = attributedString
    }

    public var description: String {
        return attributedString.description
    }

}

