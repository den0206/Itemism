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
        
    }
    
    
  
    //MARK: - UI
    
    private func configureUI() {
        
        navigationItem.title = "Setting"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .black
        
        
        /// set current user image (left bar button)
        let userImage = downloadImageFromData(picturedata: User.currentUser()!.profileImageData)
        let iv = UIImageView(image: userImage)
        iv.setDimensions(height: 32, width: 32)
        iv.layer.cornerRadius = 32 / 2
        iv.clipsToBounds = true
        iv.isUserInteractionEnabled = false
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tappedUserImage))
        iv.addGestureRecognizer(tap)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: iv)
        
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
    
    @objc func tappedUserImage() {
        
        let myItemVC = MyItemsViewController(user: User.currentUser()!)
        navigationController?.pushViewController(myItemVC, animated: true)
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
