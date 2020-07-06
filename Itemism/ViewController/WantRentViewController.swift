//
//  WantRentViewController.swift
//  Itemism
//
//  Created by 酒井ゆうき on 2020/06/30.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit

class WantRentViewController : UITableViewController {
    let user :User
    
    init(user : User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        fetchWants()
    }
    
    //MARK: - UI
    
    private func configureUI() {
        navigationItem.title = "お気に入り"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func fetchWants() {
        
        ItemService.fetchUserWants(user: user) { (items) in
            return
        }
    }
}
