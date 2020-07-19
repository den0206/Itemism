//
//  AllRequestViewController.swift
//  Itemism
//
//  Created by 酒井ゆうき on 2020/07/19.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit

class AllRequestViewController : UIViewController {
    
    let user : User
    
    var navigationHeight : CGFloat? {
        didSet {
            configureUI()
            updateView()
        }
    }
    
    //MARK: - Parts
    
    private let segmentrController : UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Requested", "欲しいもの"])
        sc.selectedSegmentIndex = 0
        sc.addTarget(self, action: #selector(handleSegment(_ :)), for: .valueChanged)
        return sc
    }()
    
    private let contaierView : UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var requestedVC : RequestedViewController = {
        let vc = RequestedViewController(user: user)
        return vc
    }()
    
    private lazy var wantVC : WantRentViewController = {
        let vc = WantRentViewController(user: user)
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
    //
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        navigationHeight = topbarHeight + 10
        
    }
    
    //MARK: - UI
    
    private func configureUI () {
        
        navigationItem.title = "Requests"
        
        let containerY : CGFloat = navigationHeight! + 50
        
        segmentrController.frame = CGRect(x: 50, y: navigationHeight!, width: 300, height: 50)
        view.addSubview(segmentrController)
        
        contaierView.frame = CGRect(x: 0, y: containerY, width: view.frame.width, height: view.frame.height - containerY)
        view.addSubview(contaierView)
        
        
    }
    
    //MARK: - Segment func
    
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
    
    //MARK: - Actiuons
    
    @objc func handleSegment(_ sender : UISegmentedControl) {
        updateView()
    }
    private func updateView() {
        if segmentrController.selectedSegmentIndex == 0 {
            remove(viewController: wantVC)
            add(viewController: requestedVC)
        } else {
            remove(viewController: requestedVC)
            add(viewController: wantVC)
        }
    }
    
    
}
