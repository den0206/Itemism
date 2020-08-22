//
//  RequestedViewController.swift
//  Itemism
//
//  Created by 酒井ゆうき on 2020/07/08.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit
import PKHUD

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
        
        cell.request = requests[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let request = requests[indexPath.row]
                
        let popviewController = RequestPopupController()
        popviewController.delegate = self
        
        popviewController.request = request
        popviewController.modalPresentationStyle = .custom
        popviewController.transitioningDelegate = self
        present(popviewController, animated: true, completion: nil)
        
    }
}

extension RequestedViewController : UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return CustomPresentationController(presentedViewController: presented, presenting: presenting)
    }
}
extension RequestedViewController : RequestPopupControllerDelegate {
    
    func handleMatching(popup: RequestPopupController, matchedUser: User) {
        
        popup.dismiss(animated: true, completion: nil)

        // TODO: - save matching fireStore
        MatchService.checkMatchExist(user: matchedUser) { (accepted) in
            
            guard !accepted else {
//                HUD.flash(.label("メッセージを送ってみましょう"), delay: 1.0)
//                
//                sleep(3)
//
                let match = Match(uid: matchedUser.uid, name: matchedUser.name, profileImageData: matchedUser.profileImageData)
                
                
                let messageVC = MessageViewController()
                messageVC.chatRoomId = Recent.startPrivateChat(currentUserId: User.currentId(), match: match)
                messageVC.membersIds = [User.currentId(), match.uid]
                
                if let profileImage = downloadImageFromData(picturedata: match.profileImageData) {
                    messageVC.profileImage = profileImage
                }
                
                messageVC.configureAccesary()
                
                self.navigationController?.pushViewController(messageVC, animated: true)
                
                return
            }
            
            MatchService.uploadMatch(currentUser: User.currentUser()!, mathedUser: matchedUser)
            

            // TODO: - present MatchVC
            let viewModel = MatchViewModel(currentUser:  User.currentUser()!, matchUser: matchedUser)
            let matchVC = MatchView(viewModel: viewModel)
            
            self.tabBarController?.view.addSubview(matchVC)
            matchVC.fillSuperview()
            
            
        }
        
        


    }
    
    

    
}
