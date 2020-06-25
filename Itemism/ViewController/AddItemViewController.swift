//
//  AddItemViewController.swift
//  Itemism
//
//  Created by 酒井ゆうき on 2020/06/22.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit

private let reuseIdentifer = "AddItemCell"

class AddItemViewController : UITableViewController {
    
    //MARK: - Item property
    var itemImages : [UIImage] = []
    var name : String?
    var desc : String?
    
    
    //MARK: - Parts
    let headerView = AddItemHeaderView()
    private var imageIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNav()
        configureTableView()
    }
    
    //MARK: - UI
    
    private func configureNav() {
        
//        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.lightGray]
        navigationItem.title = "Add Item"
        
        let closeButton = UIBarButtonItem(image: UIImage(systemName: "clear"), style: .plain, target: self, action: #selector(handleDismiss))
        closeButton.tintColor = .lightGray
        
        let doneButton = UIBarButtonItem(image: UIImage(systemName: "folder.fill.badge.plus"), style: .plain, target: self, action: #selector(handleDone))
        doneButton.tintColor = .lightGray
        
        navigationItem.leftBarButtonItem = closeButton
        navigationItem.rightBarButtonItem = doneButton
    }
    
    private func configureTableView() {
        
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemBackground

        
        tableView.tableHeaderView = headerView
        headerView.delegate = self
        
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 300)
        
        tableView.register(AddItemCell.self, forCellReuseIdentifier: reuseIdentifer)
        
        let tappedGesture = UITapGestureRecognizer(target: self, action: #selector(tappedBackground))
        
        view.addGestureRecognizer(tappedGesture)
        
    }
    
    //MARK: - Actions
    
    @objc func handleDone() {
        
        print(name,desc,itemImages)
    }
    
    @objc func handleDismiss() {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func tappedBackground() {
        self.view.endEditing(false)
    }
}

//MARK: - Tableview delegte

extension AddItemViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        AddItemSections.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifer, for: indexPath) as! AddItemCell
        
        guard let section = AddItemSections(rawValue: indexPath.section) else {return cell}
        let viewModel = AddItemViewModel(section: section)
        
        cell.delegate = self
        cell.viewModel = viewModel
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
           return 32
       }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let section = AddItemSections(rawValue: section) else {return nil}
        
        return section.title
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = AddItemSections(rawValue: indexPath.section) else {return 0}
        
        if section == .description {
            return 200
        }
        
        return 45
    }
    
}

extension AddItemViewController : AddItemHeaderViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func selectedPhoto(_ header: AddItemHeaderView, didSelect: Int) {
        self.imageIndex = didSelect
        
        let picker = UIImagePickerController()
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let selectedImage = info[.originalImage] as? UIImage else {return}
        
        headerView.buttons[imageIndex].setImage(selectedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        
        if itemImages.indices.contains(imageIndex){
            self.itemImages.remove(at: imageIndex)
        }
        
        /// uploadPhoto
        self.itemImages.insert(selectedImage, at: imageIndex)
        
    
        
        print(itemImages)
        
        dismiss(animated: true, completion: nil)
    }
    
    
}

extension AddItemViewController : AddItemCellDelegate {
    
    func updateItemInfo(cell: AddItemCell, value: String, section: AddItemSections) {
        switch section {
       
        case .name:
            self.name = value
        case .description:
            return
        }
    }
    
    func updateDescription(cell: AddItemCell, description: String) {
        self.desc = description
    }
    
    
}
