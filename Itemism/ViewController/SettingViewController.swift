//
//  SettingViewController.swift
//  Itemism
//
//  Created by 酒井ゆうき on 2020/06/21.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit
import FirebaseAuth

class SettingViewController : UITableViewController {
    
    //MARK: - Parts
    
    private let footeView = SettingFooterView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureTableView()
        
        print(User.currentUser()?.name)
    }
    
    //MARK: - UI
    
    private func configureUI() {
        
        navigationItem.title = "Setting"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .black
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleDone))
        
        
    }
    
    private func configureTableView() {
        
        tableView.separatorStyle = .none
        tableView.tableFooterView = footeView
        
        footeView.delegate = self
        footeView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 80)
        
        
    }
    
    //MARK: - Actions
    
    @objc func handleDone() {
        print("Done")
    }
}

//MARK: - Footer view Delelegate

extension SettingViewController : SettingFooterViewDelegate {
    
    func handleLogOut() {
        logOut()
    }
    
    func logOut() {
        
        do {
            try Auth.auth().signOut()
            
            UserDefaults.standard.removeObject(forKey: kCURRENTUSER)
            UserDefaults.standard.synchronize()
            
            presentLoginVC()
        } catch {
            print("Can't Log out")
        }
    }
    
    func presentLoginVC() {
        DispatchQueue.main.async {
            let loginVC = LoginViewController()
            let nav = UINavigationController(rootViewController: loginVC)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        }
    }
    
    
}
