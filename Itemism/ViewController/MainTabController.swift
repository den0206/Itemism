
//
//  MaintabController.swift
//  Itemism
//
//  Created by 酒井ゆうき on 2020/06/20.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit
import FirebaseAuth

class MainTabController : UITabBarController {
    
//    var currentUser : User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGroupedBackground
        
        checkUserIsLogin()
        
    }
    
    //MARK: - TabbarController
    
    
    func checkUserIsLogin() {
        
        
        if Auth.auth().currentUser == nil {
            
            DispatchQueue.main.async {
                let nav = UINavigationController(rootViewController: LoginViewController())
                nav.modalPresentationStyle = .fullScreen
                
                self.present(nav, animated: true, completion: nil)
            }
        } else {
            
            
            if UserDefaults.standard.object(forKey: kCURRENTUSER) == nil {
                /// set currentUser
          
                fetchCurrentUser(uid: Auth.auth().currentUser!.uid)
                
                return
            }
            
            configureTabController()
            
        }
    }
    
    private func configureTabController() {
        
        let feedVC = FeedViewController()
        let nav = createNavController(image: UIImage(systemName: "house.fill"), title: "Feeds", rootViewController: feedVC)
        
        let messageVC = RecentsViewController()
        let nav1 = createNavController(image: UIImage(systemName: "message.fill"), title: "Message", rootViewController: messageVC)
        
        let requestVC = RequestedViewController(user: User.currentUser()!)
        let nav2 = createNavController(image: UIImage(systemName: "gift.fill"), title: "Items", rootViewController: requestVC)
        
        
        let rentVC = WantRentViewController(user: User.currentUser()!)
        let nav3 = createNavController(image: UIImage(systemName: "square.grid.3x2.fill"), title: "Want", rootViewController: rentVC)
        
        let settingVC = SettingViewController()
        let nav4 = UINavigationController(rootViewController: settingVC)
        
        
        settingVC.tabBarItem.image = UIImage(systemName: "person.crop.rectangle")
        settingVC.tabBarItem.title = "Settings"
        
        viewControllers = [nav, nav1,nav2,nav3,nav4]
        
        UITabBar.appearance().tintColor = .black
        tabBar.unselectedItemTintColor = .lightGray
    
        
        
    }
    
    //MARK: - API
    
    private func fetchCurrentUser(uid : String) {
       
        AuthService.fetchCurrentUser(uid: uid) { (user) in
           
            self.configureTabController()
            
        }
    }
    
    //MARK: - Helpers
    
    private func createNavController(image : UIImage?, title :String, rootViewController : UIViewController) -> UINavigationController {
        
        let nav = UINavigationController(rootViewController: rootViewController)
        let appearence = UINavigationBarAppearance()
        appearence.configureWithOpaqueBackground()
        appearence.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.black]
        appearence.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.black]
        
        appearence.backgroundColor = .systemGroupedBackground
        
        appearence.shadowColor = .clear
        
        nav.navigationBar.standardAppearance = appearence
        nav.navigationBar.compactAppearance = appearence
        nav.navigationBar.scrollEdgeAppearance = appearence
        
        nav.navigationBar.tintColor = .black
        nav.navigationBar.layer.borderColor = UIColor.white.cgColor
        
        nav.tabBarItem.image = image
        nav.tabBarItem.title = title
        
        
        return nav
    }
}
