
//  HomeViewController.swift
//  Itemism
//
//  Created by 酒井ゆうき on 2020/06/20.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit
import FirebaseAuth

private let reuseIdentifer = "FeedCell"

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
        button.tintColor = .white
        button.backgroundColor = .lightGray
        button.setImage(#imageLiteral(resourceName: "new_tweet"), for: .normal)
        button.addTarget(self, action: #selector(handleTappedAddItem), for: .touchUpInside)
        
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
        actionButton.anchor( bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingBottom: 64, paddingRight: 16, width: 56, height: 56)
        actionButton.layer.cornerRadius = 56 / 2
        
        
        collectionView.backgroundColor = .systemGroupedBackground

        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: reuseIdentifer)
        
        collectionView.contentInset = UIEdgeInsets(top: 50, left: 25, bottom: 25, right: 24)
        collectionView.horizontalScrollIndicatorInsets = UIEdgeInsets(top: 50, left: 25, bottom: 25, right: 24)
        
        
        
    }
    
    //MARK: - API
    
    private func fetchItems() {
        
        self.tabBarController?.showPresentLoadindView(true)
        
        ItemService.fetchAllItems { (items) in
            
            self.items = items
            
            self.tabBarController?.showPresentLoadindView(false)

        }
    }
    
    //MARK: - Actions
    
    @objc func handleTappedAddItem() {
        
        let addItemVC = AddItemViewController()
        let nav = UINavigationController(rootViewController: addItemVC)
        
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
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
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let item = items[indexPath.item]
        
        let itemVC = DetailItemViewController(item: item)
        navigationController?.pushViewController(itemVC, animated: true)
    }
    
    
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
}
