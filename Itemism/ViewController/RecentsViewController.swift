//
//  MessagesViewController.swift
//  Itemism
//
//  Created by 酒井ゆうき on 2020/07/11.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit
import FirebaseFirestore

private let recentReuseIdentifer = "recentCell"
class RecentsViewController : UITableViewController {
    
    //MARK: - Property
    
    var recents = [[String : Any]]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    var recentsListner : ListenerRegistration?
    
    //MARK: - Parts
    
    private let headerView = RecentHeaderView()
    
    deinit {
        recentsListner?.remove()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        congigureTV()
        
        fetchMetch()
        fetchRecents()
        
    }
    
    //MARK: - UI
    
    private func congigureTV() {
        navigationItem.title = "Recent"
        view.backgroundColor = .systemGroupedBackground
        
        /// table view
        
        tableView.rowHeight = 100
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        
        tableView.register(RecentCell.self, forCellReuseIdentifier: recentReuseIdentifer)
        
        /// no section header
        tableView.tableHeaderView = headerView
        headerView.delegate = self
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 200)
        
        
    }
    
    //MARK: - API
    
    private func fetchMetch() {
        
        checkInternetConnection()
        
        MatchService.fetchMatch { (matches) in
            self.headerView.matches = matches
        }
    }
    
    private func fetchRecents() {
        
        recentsListner = MessageService.fetchRecent(userId: User.currentId(), completion: { (recents) in
            
            self.recents = recents
            
        })
    }
    
    
}

//MARK: - Table View Delegate

extension RecentsViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        recents.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: recentReuseIdentifer, for: indexPath) as! RecentCell
        
        cell.recent = recents[indexPath.row]
        
        return cell
    }
    
    
}

//MARK: - Recent Header view Delegate

extension RecentsViewController : RecentHeaderViewDelegate {
    
    func handleMatch(match: Match) {
        
        checkInternetConnection()
        
        /// start Chat
        let chatRoomId = Recent.startPrivateChat(currentUserId: User.currentId(), match: match)
        
        print(chatRoomId)
        
        
        
    }
    
    
}
