
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
            
            configureTabController()
        }
    }
    
    private func configureTabController() {
        
        let feedVC = FeedViewController()
        let nav = createNavController(image: UIImage(systemName: "house.fill"), title: "Items", rootViewController: feedVC)
        
        viewControllers = [nav]
        
        UITabBar.appearance().tintColor = .lightGray
        tabBar.unselectedItemTintColor = .white
    
        
        
    }
    
    //MARK: - Helpers
    
    private func createNavController(image : UIImage?, title :String, rootViewController : UIViewController) -> UINavigationController {
        
        let nav = UINavigationController(rootViewController: rootViewController)
        let appearence = UINavigationBarAppearance()
        appearence.configureWithOpaqueBackground()
        appearence.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        appearence.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        
        appearence.backgroundColor = .black
        
        appearence.shadowColor = .clear
        
        nav.navigationBar.standardAppearance = appearence
        nav.navigationBar.compactAppearance = appearence
        nav.navigationBar.scrollEdgeAppearance = appearence
        
        nav.navigationBar.tintColor = .white
        nav.navigationBar.layer.borderColor = UIColor.white.cgColor
        
        nav.tabBarItem.image = image
        nav.tabBarItem.title = title
        
        
        return nav
    }
}
