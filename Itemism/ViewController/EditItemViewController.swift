//
//  File.swift
//  Itemism
//
//  Created by 酒井ゆうき on 2020/07/03.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit

class EditItemViewController :  AddItemViewController {
    
    //MARK: - Propert
    private var item : Item
    
    init(item : Item) {
        self.item = item
        super.init(style: .plain)
        
        self.headerView.item = item

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        configureNav()
    }
    
    //MARK: - UI
    
    override func configureNav() {
        super.configureNav()
        navigationItem.title = "Edit Item"
        
    }
    
    
}
