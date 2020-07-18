//
//  ProfileViewController.swift
//  
//
//  Created by 酒井ゆうき on 2020/07/18.
//

import UIKit

class ProfileViewController : UIViewController {
    
    let user : User
    
    var navigationHeight : CGFloat? {
        didSet {
            configureUI()
            updateView()
        }
    }
    
    //MARK: - Parts
    
    private let segmentrController : UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Item", "Profile"])
        sc.selectedSegmentIndex = 0
        sc.addTarget(self, action: #selector(handleSegment(_ :)), for: .valueChanged)
        return sc
    }()
    private let contaierView : UIView = {
        let view = UIView()
        view.backgroundColor = .red
        return view
    }()
    
    private lazy var myItemsViewController : MyItemsViewController = {
        let itemVC = MyItemsViewController(user: user)
        return itemVC
    }()
    
    private lazy var settingViewController : SettingViewController = {
        let settingVC = SettingViewController()
        
        return settingVC
    }()
    
    private let exampleVIew : UIViewController = {
        let vc = UIViewController()
        vc.view.backgroundColor = .purple
        return vc
    }()
    
    
    init(user : User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        navigationHeight = (navigationController?.navigationBar.frame.maxY)! + 10
        
    }
    
    
    
    //MARK: - UI
    
    private func configureUI() {
        
        if user.userType == .current {
            navigationItem.title = "Setting"
        } else {
            navigationItem.title = "\(user.name) さん"
        }
        /// set current user image (left bar button)
        let userImage = downloadImageFromData(picturedata: user.profileImageData)
        let iv = UIImageView(image: userImage)
        iv.setDimensions(height: 32, width: 32)
        iv.layer.cornerRadius = 32 / 2
        iv.clipsToBounds = true
        iv.isUserInteractionEnabled = false
        
//        let tap = UITapGestureRecognizer(target: self, action: #selector(tappedUserImage))
//        iv.addGestureRecognizer(tap)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: iv)
        
//        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleDone))
        
        navigationController?.navigationBar.tintColor = .black
        
       
        let conteinerY : CGFloat = navigationHeight! + 50
        
  
        segmentrController.frame = CGRect(x: 50, y: navigationHeight!, width: 300, height: 50)
        view.addSubview(segmentrController)
        
        contaierView.frame = CGRect(x: 0, y: conteinerY, width: view.frame.width, height: view.frame.height - conteinerY)
        view.addSubview(contaierView)
        
        
    }
    
    //MARK: - segment func
    
    private func add(viewController : UIViewController) {
        addChild(viewController)
        
        contaierView.addSubview(viewController.view)
        viewController.view.frame = contaierView.bounds
        viewController.view.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        viewController.didMove(toParent: self)
    }
    
    private func remove(viewController : UIViewController) {
        
        viewController.willMove(toParent: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
    
    }
    
    //MARK: - Actions
    
    @objc func handleSegment(_ sender : UISegmentedControl) {
        updateView()
    }
    
    private func updateView() {
        if segmentrController.selectedSegmentIndex == 0 {
            
            switch user.userType {
                
                /// seting view
            case .current:
                remove(viewController: settingViewController)
                add(viewController: myItemsViewController)
            case .another:
                /// user profileView (example = anotheruserVC)
                remove(viewController: exampleVIew)
                add(viewController: myItemsViewController)
                return
            }
            
        } else {
            
            switch user.userType {
                
            case .current:
                remove(viewController: myItemsViewController)
                add(viewController: settingViewController)
            case .another:
                /// user profileView (example = anotheruserVC)
                remove(viewController: myItemsViewController)
                add(viewController: exampleVIew)

                return
            }
            
        }
    }
    
}
