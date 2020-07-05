//
//  DetailItemViewController.swift
//  Itemism
//
//  Created by 酒井ゆうき on 2020/06/27.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit
import PKHUD

class DetailItemViewController : UIViewController {
    
    
    //MARK: - Property
    
    var item : Item

    
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
        
        print(item.wanted)
        
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

extension DetailItemViewController : BottomControlsStackViewDelegate, EditItemViewControllerDelegate {
   
    func handleEdit() {
        
        let editVC = EditItemViewController(item: item)
        editVC.delegate = self
        let nav = UINavigationController(rootViewController: editVC)
        nav.modalPresentationStyle = .fullScreen
        
        present(nav, animated: true, completion: nil)
        
    }
    
    func compDelete(item: Item) {
        self.item = item
        configureUI()
        configureCardView()
    }
    
    
    func handleDelete() {
        
        let alert = UIAlertController(title: "確認", message: "\(item.name)を削除してもよろしいでしょうか?", preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .default) { (_) in
            
            self.navigationController?.showPresentLoadindView(true, message: "Delete...")

            /// delete firestore
            ItemService.deleteItem(itemId: self.item.id) { (error) in
                
                if error != nil {
                    self.navigationController?.showPresentLoadindView(false)
                    self.showAlert(title: "Recheck", message: error!.localizedDescription)
                    
                    return
                }
                
                self.navigationController?.showPresentLoadindView(false)

                
                self.navigationController?.popViewController(animated: true)
            }
            
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(ok)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func handleFavorite() {
        
        guard !item.wanted else {
            HUD.flash(.label("申請済みです。"), delay: 1.0)
            return
        }
        
        ItemService.wantItem(item: item, wanted: false) { (error) in
            self.item.wanted = true
            HUD.flash(.labeledSuccess(title: "お気に入り", subtitle: "追加しました"), delay: 1.0)
        }
        
        
        //        item.wanted.toggle()
        
    }
    
    func handleUnfavorite() {
        guard item.wanted else {
            HUD.flash(.label("まだ申請していません。"), delay: 1.0)
            return
        }
        
        ItemService.wantItem(item: item, wanted: true) { (error) in
            self.item.wanted = false
            HUD.flash(.labeledSuccess(title: "お気に入り", subtitle: "から削除しました"), delay: 1.0)
        }
        
        
    }
    
}
