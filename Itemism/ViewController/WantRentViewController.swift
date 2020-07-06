//
//  WantRentViewController.swift
//  Itemism
//
//  Created by 酒井ゆうき on 2020/06/30.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit

private let reuserIdentifer = "WantCell"

class WantRentViewController : UICollectionViewController {
    
    //MARK: - Property
    
    let user :User
    var lineSpacing : CGFloat = 8
    
    var wantsItems = [Item]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    
    init(user : User) {
        self.user = user
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.tabBarController?.showPresentLoadindView(true)
        
        configureCV()
//        fetchWants()
    }
    
    //MARK: - UI
    
    private func configureCV() {
        navigationItem.title = "お気に入り"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        collectionView.backgroundColor = .white
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuserIdentifer)
        
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
    }
    
    private func fetchWants() {
        
        checkInternetConnection(tab: self.tabBarController)
        
        ItemService.fetchUserWants(user: user) { (items) in
            
            self.wantsItems = items
            
            self.tabBarController?.showPresentLoadindView(false)
        }
    }
}

//MARK: - collectionview Delegate

extension WantRentViewController {
    

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuserIdentifer, for: indexPath)
        
        cell.backgroundColor = .lightGray
        cell.layer.cornerRadius = 13 / 2
        
        return cell
    }
    
}

extension WantRentViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (view.frame.width - lineSpacing) / 3
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return lineSpacing / 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}
