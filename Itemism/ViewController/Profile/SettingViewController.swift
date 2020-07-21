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
    var userType : UserType {
        return user.userType
    }
        
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
        
        if userType == .current {
            tableView.tableFooterView = footeView
            footeView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 150)
            footeView.delegate = self
        } else {
            let noButtonView = UIView()
            tableView.tableFooterView = noButtonView
            noButtonView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 32)
            
            let bottomLine = UIView()
            bottomLine.backgroundColor = .systemGroupedBackground
            noButtonView.addSubview(bottomLine)
            bottomLine.anchor(top: noButtonView.topAnchor,left : noButtonView.leftAnchor,right: noButtonView.rightAnchor, width: noButtonView.frame.width, height: 32)
            
            
        }
        
        
        tableView.register(SettingUserCell.self, forCellReuseIdentifier: settingIdentifer)
        
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
        
        guard let section = SettingSections(rawValue: indexPath.section) else {return cell}
        
        let vm = settingViewModel(user: user, section: section)
        
        cell.settingViewModel = vm
        cell.delegate = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let section = SettingSections(rawValue: section) else {return String()}
        
        
        return section.description
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        guard let section = SettingSections(rawValue: indexPath.section) else {return 0}
        
        if section == .bio {
            return 200
        }
        
        return 45
    }
}

//MARK: - cell delegate

extension SettingViewController : SettingUserCellDelegate {
    

    func updateUserInfo(cell: SettingUserCell, value: String, section: SettingSections) {
        
        switch section {
      
        case .name:
            user.name = value
        case .bio:
            user.bio = value
        }
        
        footeView.saveButton.backgroundColor = .blue
    }
    
    
}

//MARK: - Footer view Delelegate (currentUser)

extension SettingViewController : SettingFooterViewDelegate {
    
    func handleSave() {
        view.endEditing(true)
         
        
        UserService.updateUser(user: user) { (error) in
            if error != nil {
                self.showAlert(title: "Error", message: error!.localizedDescription)
                return
            }

            guard var ud = UserDefaults.standard.dictionary(forKey: kCURRENTUSER) else {return}
            
            ud[kFULLNAME] = self.user.name
            ud[kBIO] = self.user.bio
            
            UserDefaults.standard.set(ud, forKey: kCURRENTUSER)
            UserDefaults.standard.synchronize()

        }
    }
    
    
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
