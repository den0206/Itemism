//
//  exDetailItemViewController.swift
//  Itemism
//
//  Created by 酒井ゆうき on 2020/07/18.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit
import PKHUD
import SKPhotoBrowser

class exDetailItemViewController : UITableViewController {

    //MARK: - Property
    
    var item : Item

    
    //MARK: - Parts
    
    let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    
    private let header = DetailItemHeaderView()
    private lazy var bottomStack = BottomControlsStackView(type: item.user!.userType)
    

    
    init(item : Item) {
        self.item = item
        super.init(nibName: nil, bundle: nil)
        
        ItemService.checkWanted(item: item) { (wanted) in
            self.item.wanted = wanted
            print(item.wanted)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureBlurView()
        
        
       
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
         let closeButton = UIBarButtonItem(image: UIImage(systemName: "clear"), style: .plain, target: self, action: #selector(handleDismiss))
               closeButton.tintColor = .lightGray
        closeButton.tintColor = .black
        navigationItem.leftBarButtonItem = closeButton
        
    }
    
    private func configureBlurView() {
        
        self.tableView.backgroundColor = .clear
        blurEffectView.frame = tableView.frame
        tableView.backgroundView = blurEffectView
        
        header.delegate = self
        header.imageUrls = item.imageLinks
        
        
        
        
        /// viewController
//        blurEffectView.frame = self.view.frame
//        self.view.insertSubview(blurEffectView, at: 0)
//
//        let tap = UITapGestureRecognizer(target: self, action: #selector(handleDismiss))
//        blurEffectView.addGestureRecognizer(tap)
        
    }
    
    //MARK: - Actions
    
    @objc func handleDismiss() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}

extension exDetailItemViewController {
    
    /// header & footer
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 200
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return header
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return bottomStack
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 150
    }
}

//MARK: - DetailItem HeaderView Delegate

extension exDetailItemViewController : DetailItemHeaderViewDelegate {
    
    func presentPhotoBrowser(_ view: DetailItemHeaderView, browser: SKPhotoBrowser) {
        present(browser, animated: true, completion: nil)
    }
    
    
}




