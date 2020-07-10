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
//
//        self.tabBarController?.addChild(popupViewController)
//        popupViewController.didMove(toParent: self.tabBarController)
        
        configureTV()
//        fetchRequest()
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
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdetifer, for: indexPath) as! RerquestCell
        
//        cell.request = requests[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
//        let request = requests[indexPath.row]
        
//        popupViewController.request = request
        
        let popviewController = RequestPopupController()
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
