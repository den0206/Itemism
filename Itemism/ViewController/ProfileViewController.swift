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
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        navigationHeight = (navigationController?.navigationBar.frame.maxY)! + 10
        
    }
    
    
    
    //MARK: - UI
    
    private func configureUI() {
        navigationItem.title = "Setting"
//        navigationController?.navigationBar.prefersLargeTitles = true
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
            remove(viewController: exampleVIew)
            add(viewController: myItemsViewController)
        } else {
            remove(viewController: myItemsViewController)
            add(viewController: exampleVIew)
        }
    }
    
}
