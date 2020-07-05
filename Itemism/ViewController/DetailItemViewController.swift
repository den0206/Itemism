//
//  DetailItemViewController.swift
//  Itemism
//
//  Created by 酒井ゆうき on 2020/06/27.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit

class DetailItemViewController : UIViewController {
    
    
    //MARK: - Property
    
    let item : Item
//
//    var userType : UserType {
//        guard let user = item.user else {return .another}
//        
//        if user.uid == User.currentId() {
//            return .current
//        } else {
//            return .another
//        }
//    }
    
    //MARK: - Parts
    private lazy var bottomStack = BottomControlsStackView(type: item.user!.userType)
    
    
    private let deckView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        return view
    }()
    
    init(item : Item) {
        self.item = item
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureCardView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = false
        
    }
    
    //MARK: - UI
    
    private func configureUI() {
        
        navigationItem.title = item.name
        
        view.backgroundColor = .systemGroupedBackground
        
        let stack = UIStackView(arrangedSubviews: [deckView, bottomStack])
        stack.axis = .vertical
        
        bottomStack.delegate = self
        view.addSubview(stack)
        stack.anchor(top : view.safeAreaLayoutGuide.topAnchor,left : view.leftAnchor,bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor)
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = .init(top: 0, left: 12, bottom: 0, right: 12)
        stack.bringSubviewToFront(deckView)
        
    }
    
    private func configureCardView() {
        
        let cardView = CardView(type: .Detail, item: item)

        deckView.addSubview(cardView)
        cardView.fillSuperview()
    }
}

extension DetailItemViewController : BottomControlsStackViewDelegate {
    
    func handleEdit() {
        
        let editVC = EditItemViewController(item: item)
        let nav = UINavigationController(rootViewController: editVC)
        nav.modalPresentationStyle = .fullScreen

        present(nav, animated: true, completion: nil)
        
    }
    func handleDelete() {
        
        let alert = UIAlertController(title: "確認", message: "\(item.name)を削除してもよろしいでしょうか?", preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .default) { (_) in

            /// delete firestore
            ItemService.deleteItem(itemId: self.item.id) { (error) in
                
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
    
    func handleFavorite() {
        print("Fav")
    }
    
    func handleUnfavorite() {
        print("unFav")

    }
    
}
