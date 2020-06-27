//
//  DetailItemViewController.swift
//  Itemism
//
//  Created by 酒井ゆうき on 2020/06/27.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit

class DetailItemViewController : UIViewController {
    
    let item : Item
    
    init(item : Item) {
        self.item = item
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .red
        print(item)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = false
        
    }
}
