//
//  PopupViewController.swift
//  Itemism
//
//  Created by 酒井ゆうき on 2020/07/09.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit

class RequestPopupController : UITableViewController {
    
    var request : Request?
    
    //MARK: - Parts
    
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGroupedBackground
        
       
    }
   
    @objc func btnTapped(sender : UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}

extension RequestPopupController {
    
}

