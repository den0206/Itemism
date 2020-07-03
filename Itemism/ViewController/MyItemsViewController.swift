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
    
    private lazy var bottomStack = BottomControlsStackView(type: user.userType)
    
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
        bottomStack.delegate = self
        
        view.addSubview(stack)
        stack.anchor(top : view.safeAreaLayoutGuide.topAnchor,left : view.leftAnchor,bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor)
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = .init(top: 0, left: 12, bottom: 0, right: 12)
        stack.bringSubviewToFront(deckView)
        
    }
    
    private func configureCardView() {
        
        items.forEach { (item) in
            
            let cardView = CardView(type: .Default, item: item)
            cardView.delegate = self
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

extension MyItemsViewController : BottomControlsStackViewDelegate {
    
    
    /// currentType only for now
    
    func handleEdit() {
        guard let topCard = topCardView else {return}
        
        let editVC = EditItemViewController(item: topCard.item)
        let nav = UINavigationController(rootViewController: editVC)
        nav.modalPresentationStyle = .fullScreen
        
        present(nav, animated: true, completion: nil)
        
    }
    
    func handleDelete() {
        guard let topCard = topCardView else {return}
        
        let alert = UIAlertController(title: "確認", message: "\(topCard.item.name)を削除してもよろしいでしょうか?", preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .default) { (_) in
            self.swipeAnimation(right: false)
            
            /// delete firestore
            ItemService.deleteItem(itemId: topCard.item.id) { (error) in
                
                if error != nil {
                    self.showAlert(title: "Recheck", message: error!.localizedDescription)
                    
                    return
                }
            }
            
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(ok)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
        
    }

    
    
}

extension MyItemsViewController : CardViewDelegate {
    

    func handleCardView(cardView: CardView, didLike: Bool) {
        /// configure topCardView
        
        cardView.removeFromSuperview()
        
        self.cardViews.removeAll(where: {cardView == $0})
        
        self.topCardView = cardViews.last
        
    }
    
    
}

//MARK: - For Items Actiuons

extension MyItemsViewController {
    
    func swipeAnimation(right : Bool) {
        /// swipe Left
        let translation : CGFloat = right ? 700 : -700
        
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
            self.topCardView?.frame = CGRect(x: translation, y: 0, width: (self.topCardView?.frame.width)!, height: (self.topCardView?.frame.height)!)
            
        }) { (_) in
            self.topCardView?.removeFromSuperview()
            
            guard !self.cardViews.isEmpty else {return}
            self.cardViews.remove(at: self.cardViews.count - 1)
            self.topCardView = self.cardViews.last
        }
    }
}
