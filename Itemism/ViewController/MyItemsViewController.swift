//
//  MyItemsViewController.swift
//  Itemism
//
//  Created by 酒井ゆうき on 2020/06/28.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit

class MyItemsViewController : UIViewController {
    
    //MARK: - Property
    
    let user : User
    
    var items = [Item]() {
        didSet {
            configureCardView()
        }
    }
    
    private var cardViews = [CardView]()
    private var topCardView : CardView?
    
    //MARK: - Parts
    private let headerView : UIView = {
        let view = UIView()
        view.backgroundColor = .systemGroupedBackground
        return view
    }()
    
    private let bottomStack = BottomControlsStackView()
    
    private let deckView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        return view
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
        
        
        self.tabBarController?.showPresentLoadindView(true)
        
        configureUI()
        
        fetchUserItems()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        
        
    }
    
    //MARK: - UI
    
    private func configureUI() {
        view.backgroundColor = .systemGroupedBackground
        
        /// blank view
        headerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        let stack = UIStackView(arrangedSubviews: [headerView, deckView, bottomStack])
        stack.axis = .vertical
        
        view.addSubview(stack)
        stack.anchor(top : view.safeAreaLayoutGuide.topAnchor,left : view.leftAnchor,bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor)
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = .init(top: 0, left: 12, bottom: 0, right: 12)
        stack.bringSubviewToFront(deckView)
        
    }
    
    private func configureCardView() {
        
        items.forEach { (item) in
            
            let cardView = CardView(type: .Default, item: item)
            deckView.addSubview(cardView)
            cardView.fillSuperview()
        }
        
        cardViews = deckView.subviews.map({($0 as? CardView)!})
        print(cardViews)
        topCardView = cardViews.last
        
        

        
        
    }
    //MARK: - API
    
    func fetchUserItems() {
        
        ItemService.fetchUserItems(user: user) { (items) in
            self.items = items
            
            self.tabBarController?.showPresentLoadindView(false)
            print(items.count)
        }
    }
}
