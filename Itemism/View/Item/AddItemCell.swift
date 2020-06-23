//
//  AddItemCell.swift
//  Itemism
//
//  Created by 酒井ゆうき on 2020/06/23.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit

class AddItemCell : UITableViewCell {
    
    var viewModel : AddItemViewModel! {
        didSet {
            congigure()
        }
    }
    
    //MARK: - Parts
    
    lazy var inputField : UITextField = {
        let tf = UITextField()
        tf.borderStyle = .none
        tf.font = UIFont.systemFont(ofSize: 16)

        
        let paddingView = UIView()
        paddingView.setDimensions(height: 50, width: 20)
        tf.leftView = paddingView
        tf.leftViewMode = .always
        return tf
    }()
    
    private let descriptionTextView = InputTextView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
//
        addSubview(inputField)
        inputField.fillSuperview()
//
        addSubview(descriptionTextView)
        descriptionTextView.anchor(top :topAnchor,left: leftAnchor,bottom: bottomAnchor,right: rightAnchor,paddingTop: 8,paddingLeft: 8,paddingRight: 8)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func congigure() {
        
        inputField.placeholder = viewModel.placeholder
        descriptionTextView.placeholderLabel.text = viewModel.placeholder
        
        inputField.isHidden = viewModel.shoulHideInputField
        descriptionTextView.isHidden = viewModel.shoulHideTextView
        
    }
}
