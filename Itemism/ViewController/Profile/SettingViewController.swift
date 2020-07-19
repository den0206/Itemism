//
//  SettingViewController.swift
//  Itemism
//
//  Created by 酒井ゆうき on 2020/06/21.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit
import FirebaseAuth

private let settingIdentifer = "SettingCell"
class SettingViewController : UITableViewController {
    
    //MARK: - Parts
    let user : User
    
    private lazy var headerView = UserProfileHeaderView(userImage: downloadImageFromData(picturedata: user.profileImageData)!)
    
    private let footeView = SettingFooterView()
    
    init(user : User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        
    }
    
    
  
    //MARK: - UI
    
    
    private func configureTableView() {
        
        tableView.separatorStyle = .none

        tableView.tableHeaderView = headerView
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 100)
        
        tableView.tableFooterView = footeView
        footeView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 80)
        footeView.delegate = self
        
        tableView.register(SettingUserCell.self, forCellReuseIdentifier: settingIdentifer)
        
    }
    
    //MARK: - Actions
    
    @objc func handleDone() {
        print("Done")
        
        /// set as UserDefaults
//
//        var currentUserDic = UserDefaults.standard.dictionary(forKey: kCURRENTUSER)
//        currentUserDic?[kNAME] = ""
//
//        UserDefaults.standard.setValue(currentUserDic, forKey: kCURRENTUSER)
    }
    
}

extension SettingViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return SettingSections.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: settingIdentifer, for: indexPath) as! SettingUserCell
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let section = SettingSections(rawValue: section) else {return String()}
        
        return section.description
    }
}

//MARK: - Footer view Delelegate (currentUser)

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
