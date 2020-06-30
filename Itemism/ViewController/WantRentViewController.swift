//
//  WantRentViewController.swift
//  Itemism
//
//  Created by 酒井ゆうき on 2020/06/30.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit

class WantRentViewController : UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    //MARK: - UI
    
    private func configureUI() {
        navigationItem.title = "お気に入り"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}
