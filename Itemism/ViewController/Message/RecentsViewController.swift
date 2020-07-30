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
    
    var profileImages = [UIImage]()
    
    var recentsListner : ListenerRegistration?
    
    //MARK: - Parts
    
    private let headerView = RecentHeaderView()
    
    deinit {
        recentsListner?.remove()
        
        print("DEBUG :Deinit")
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
    
    //MARK: - Helper
    
    private func presentMessageVC(chatroomId : String,members : [String], membersToPush : [String], profileImage : UIImage?) {
        
        let messageVC = MessageViewController()
        messageVC.chatRoomId = chatroomId
        messageVC.membersIds = members
        messageVC.membersToPush = membersToPush
        
        if profileImage != nil {
            messageVC.profileImage = profileImage!
        }
        
        messageVC.configureAccesary()

        /// avoid Delay
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(messageVC, animated: true)
        }
//        
    }
    
    
}

//MARK: - Table View Delegate

extension RecentsViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recents.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: recentReuseIdentifer, for: indexPath) as! RecentCell
        
        cell.recent = recents[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let recent = recents[indexPath.row]
        
        
        /// private chat image
        let currentCell = tableView.cellForRow(at: indexPath) as! RecentCell

        let profileImage = currentCell.profileImageView.image
        
        // TODO: - present MessageVC
        
        let chatRoomId = (recent[kCHATROOMID] as? String)!
        let members = (recent[kMEMBERS] as? [String])!
        let membersToPush = (recent[kMEMBERSTOPUSH] as? [String])!

        presentMessageVC(chatroomId: chatRoomId, members: members, membersToPush: membersToPush, profileImage : profileImage)

        
    }
}

//MARK: - Recent Header view Delegate

extension RecentsViewController : RecentHeaderViewDelegate{
 
    
    func handleMatch(match: Match) {
        
        checkInternetConnection()
        
        // TODO: - present MessageVC

        /// start Chat
        let chatRoomId = Recent.startPrivateChat(currentUserId: User.currentId(), match: match)
        let members = [User.currentId(), match.uid]
        let membersToPush = [User.currentId(), match.uid]
        
        let profileImage = downloadImageFromData(picturedata: match.profileImageData)
        
        presentMessageVC(chatroomId: chatRoomId, members: members, membersToPush: membersToPush, profileImage: profileImage)
        
        
        
    }
    
    
}
