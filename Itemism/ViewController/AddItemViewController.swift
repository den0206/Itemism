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
    
    //MARK: - Partss
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
        
        
    }
    
    //MARK: - Actions
    
    @objc func handleDone() {
        print("Done")
    }
    
    @objc func handleDismiss() {
        
        self.dismiss(animated: true, completion: nil)
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
            return 100
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
        
        /// uploadPhoto
        
        dismiss(animated: true, completion: nil)
    }
    
    
}
