//
//  MessagesViewController.swift
//  Itemism
//
//  Created by 酒井ゆうき on 2020/07/11.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit

class RecentsViewController : UITableViewController {
    
    private let headerView = RecentHeaderView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        congigureTV()
        fetchMetch()
    }
    
    //MARK: - UI
    
    private func congigureTV() {
        navigationItem.title = "Recent"
        view.backgroundColor = .systemGroupedBackground
        
        /// table view
        
        tableView.rowHeight = 100
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        
        /// no section header
        tableView.tableHeaderView = headerView
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 200)
        
        
    }
    
    //MARK: - API
    
    private func fetchMetch() {
        
        checkInternetConnection()
        
        MatchService.fetchMatch { (matches) in
            self.headerView.matches = matches
        }
    }
    
    
}

//MARK: - Table View Delegate

extension RecentsViewController {
    
}
