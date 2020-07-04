//
//  AddItemCell.swift
//  Itemism
//
//  Created by 酒井ゆうき on 2020/06/23.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit

protocol AddItemCellDelegate : class {
    func updateItemInfo(cell : AddItemCell, value : String, section : itemtemSections)
    func updateDescription(cell : AddItemCell, description : String)
}

class AddItemCell : UITableViewCell {
    
    var newItemVM : AddItemViewModel? {
        didSet {
            congigure()
        }
    }
    
    var editItemVM : EditItemViewModel? {
        didSet {
            congigure()
            
        }
    }
    
    weak var delegate : AddItemCellDelegate?
    
    //MARK: - Parts
    
    lazy var inputField : UITextField = {
        let tf = UITextField()
        tf.borderStyle = .none
        tf.font = UIFont.systemFont(ofSize: 16)

        
        let paddingView = UIView()
        paddingView.setDimensions(height: 50, width: 20)
        
        tf.leftView = paddingView
        tf.leftViewMode = .always
        tf.addTarget(self, action: #selector(editindDidEnd), for: .editingDidEnd)
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
        descriptionTextView.delegate = self
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func congigure() {
        
        guard let viewModel : ItemViewModel = newItemVM ?? editItemVM else {return}
        
        
        inputField.placeholder = viewModel.placeholder
        descriptionTextView.placeholderLabel.text = viewModel.placeholder
        
        inputField.isHidden = viewModel.shoulHideInputField
        descriptionTextView.isHidden = viewModel.shoulHideTextView
        
        
        if editItemVM != nil {
            inputField.text = editItemVM?.value
            descriptionTextView.text = editItemVM?.value
            descriptionTextView.placeholderLabel.isHidden = true
        }
        
        
    }
    
    //MARK: - Actiuons
    
    @objc func editindDidEnd(sender : UITextField) {
        guard let value = sender.text else {return}
        
        guard let viewModel : ItemViewModel = newItemVM ?? editItemVM else {return}
        
        delegate?.updateItemInfo(cell: self, value: value, section: viewModel.section)

    }
}

extension AddItemCell : UITextViewDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        delegate?.updateDescription(cell: self, description: textView.text)
    }
}
