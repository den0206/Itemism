//
//  RequestedViewController.swift
//  Itemism
//
//  Created by 酒井ゆうき on 2020/07/08.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit

private let reuseIdetifer = "RequestCell"

class RequestedViewController : UITableViewController {
    
    //MARK: - Property
    let user : User
    
    var requests = [Request]() {
        
        didSet {
            tableView.reloadData()
        }
    }
    
    init(user : User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        configureTV()
        fetchRequest()
    }
    
    //MARK: - UI
    
    private func configureTV() {
        
        navigationItem.title = "リクエスト一覧"
        
        tableView.backgroundColor = .systemGroupedBackground
        tableView.rowHeight = 80
        tableView.tableFooterView = UIView()
        
        tableView.register(RerquestCell.self, forCellReuseIdentifier: reuseIdetifer)
        
    }
    
    //MARK: - API
    
    private func fetchRequest() {
        
        checkInternetConnection()
        
        self.tabBarController?.showPresentLoadindView(true)
        
        ItemService.fetchRequest(user: user) { (requests) in
            self.requests = requests
            
            self.tabBarController?.showPresentLoadindView(false)

        }
    }
}

//MARK: - UI TableView Delegate

extension RequestedViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requests.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdetifer, for: indexPath) as! RerquestCell
        
        return cell
    }
}
