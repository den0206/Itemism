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
    
    private let refreshController = UIRefreshControl()
    
    
    init(user : User) {
        self.user = user
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.showPresentLoadindView(true)
        
        configureCV()
        fetchWants()
    }
    
    //MARK: - UI
    
    private func configureCV() {
        navigationItem.title = "お気に入り"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        collectionView.backgroundColor = .systemGroupedBackground
        
        /// refresh controller
        collectionView.refreshControl = refreshController
        refreshController.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        
        collectionView.register(WantRentCell.self, forCellWithReuseIdentifier: reuserIdentifer)
        
//        collectionView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
//        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
    }
    
    //MARK: - Actions
    
    @objc func handleRefresh() {
        refreshController.beginRefreshing()
        
        fetchWants()
    }
    
    //MARK: - API
    
    private func fetchWants() {
        
        checkInternetConnection(tab: self.tabBarController)
        
        ItemService.fetchUserWants(user: user) { (items) in
            
            self.wantsItems = items
            
            self.tabBarController?.showPresentLoadindView(false)
            self.refreshController.endRefreshing()
        }
    }
}

//MARK: - collectionview Delegate

extension WantRentViewController {
    

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return wantsItems.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuserIdentifer, for: indexPath) as! WantRentCell
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPress(_:)))
        
        cell.addGestureRecognizer(longPress)
        
        cell.item = wantsItems[indexPath.item]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let item = wantsItems[indexPath.item]
       
        
        let itemVC = DetailItemViewController(item: item)
        navigationController?.pushViewController(itemVC, animated: true)
    }
    
    //MARK: - long Press Cell (delete)
    
    @objc func longPress(_ longpressGestureRecognizer : UILongPressGestureRecognizer) {
        
        if longpressGestureRecognizer.state == UIGestureRecognizer.State.began {
            let touchPoint = longpressGestureRecognizer.location(in: collectionView)
            if let index = collectionView.indexPathForItem(at: touchPoint) {
                deleteWanItemt(index: index)
            }
        }
        
    }
    
    private func deleteWanItemt(index : IndexPath) {
        let item = wantsItems[index.item]
        let alert = UIAlertController(title: "Delete", message: "\(item.name)を削除してもよろしいでしょうか？", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (_) in
            self.collectionView.deleteItems(at: [index])
            ///  reload    simultaneously
            self.wantsItems.remove(at: index.item)
            
            // TODO: - delete item from Firestore
            ItemService.wantItem(item: item, wanted: true) { (error) in
                if error != nil {
                    let mess = error!.localizedDescription
                    self.showAlert(title: "Error", message: mess)
                    
                    return
                }
                
            }
            
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    
}

extension WantRentViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (view.frame.width - lineSpacing) / 3
        return CGSize(width: width, height: width + 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return lineSpacing / 2
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    //// cell margin
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20 , left: 2 , bottom: 20 , right: 2 )

    }
}
