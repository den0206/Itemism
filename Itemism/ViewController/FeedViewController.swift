
//  HomeViewController.swift
//  Itemism
//
//  Created by 酒井ゆうき on 2020/06/20.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit
import FirebaseAuth

private let reuseIdentifer = "FeedCell"
private let headerIdentifer = "headerIdentifer"

class FeedViewController : UICollectionViewController {
    
    
    //MARK: - Property
    
    var items = [Item]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    //MARK: - Parts
    
    
    let actionButton : UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .black
//        button.backgroundColor = .lightGray
        button.setImage(#imageLiteral(resourceName: "new_tweet"), for: .normal)
        button.addTarget(self, action: #selector(handleTappedAddItem), for: .touchUpInside)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        
        return button
    }()
    
    let refreshButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "refresh_circle").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleRefresh), for: .touchUpInside)
        
        
        return button
    }()
    
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.showPresentLoadindView(true)
        
//        print(UserDefaults.standard.dictionary(forKey: kCURRENTUSER))
        
        configureCV()
        fetchItems()

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
    }
    
    //MARK: - UI
    
    private func configureCV() {
        
        view.addSubview(actionButton)
        actionButton.anchor( bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingBottom: 16, paddingRight: 16, width: 48, height: 48)
        actionButton.layer.cornerRadius = 48 / 2
        
        view.addSubview(refreshButton)
        refreshButton.anchor(top : view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingTop: 16, paddingLeft: 16,width: 56, height: 56)
        refreshButton.layer.cornerRadius = 56 / 2
        
        
        collectionView.backgroundColor = .systemGroupedBackground

        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: reuseIdentifer)
//        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifer)
        
        collectionView.contentInset = UIEdgeInsets(top: 50, left: 25, bottom: 25, right: 24)
        collectionView.horizontalScrollIndicatorInsets = UIEdgeInsets(top: 50, left: 25, bottom: 25, right: 24)
        
        
        
    }
    
    //MARK: - API
    
    private func fetchItems() {
        
        if Reachabilty.HasConnection() {
            ItemService.fetchAllItems { (items) in
                
                self.items = items
                
                self.tabBarController?.showPresentLoadindView(false)
                
            }
        } else {
            
            self.tabBarController?.showPresentLoadindView(false)
            self.showAlert(title: "Recheck", message: "No Internet Connections")
        }
     
    }
    
    //MARK: - Actions
    
    @objc func handleTappedAddItem() {
        
        let addItemVC = AddItemViewController()
        let nav = UINavigationController(rootViewController: addItemVC)
        
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    @objc func handleRefresh() {
        self.tabBarController?.showPresentLoadindView(true)
        fetchItems()
        
    }
    
}


//MARK: - UIcollectionView Delegate

extension FeedViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifer, for: indexPath) as! FeedCell
        cell.item = items[indexPath.item]
        
        cell.delegate = self
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let item = items[indexPath.item]
        
//        let detailVC = DetailItemView(item: item)
//        self.tabBarController?.view.addSubview(detailVC)
//        detailVC.fillSuperview()
//
//
        let itemVC = exDetailItemViewController(item: item)
        let nav = UINavigationController(rootViewController: itemVC)
        nav.modalPresentationStyle = .overFullScreen
        present(nav, animated: true, completion: nil)
//        navigationController?.pushViewController(itemVC, animated: true)
    }
    
    //MARK: - header & footer
    
//    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//
//        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifer, for: indexPath)
//
//        return header
//    }
    
    
}

extension FeedViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellWidth = view.frame.width - 75
        let cellHeight = view.frame.height - 300
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 25
    }
    
    ///headerSize
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        return CGSize(width: 100, height: 0)
//    }
}

//MARK: - Feed Cell delegate

extension FeedViewController : FeedCellDelegate {
    
    func tappedUserImage(feedCell: FeedCell, user: User) {
        let profileVC  = ProfileViewController(user:user)
        self.navigationController?.pushViewController(profileVC, animated: true)
    }
    
    
}
