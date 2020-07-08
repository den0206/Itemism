//
//  RequestedViewController.swift
//  Itemism
//
//  Created by 酒井ゆうき on 2020/07/08.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit

class RequestedViewController : UITableViewController {
    
    //MARK: - Property
    let user : User
    
    var requests = [Request]()
    
    init(user : User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchRequest()
    }
    
    //MARK: - API
    
    private func fetchRequest() {
        
        checkInternetConnection()
        
        ItemService.fetchRequest(user: user) { (requests) in
            self.requests = requests
            
            print(requests.count)
            
        }
    }
}
