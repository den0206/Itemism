//
//  File.swift
//  Itemism
//
//  Created by 酒井ゆうき on 2020/07/03.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit

private let reuseIdentifer = "AddItemCell"

class EditItemViewController : AddItemViewController {
    
    //MARK: - Propert
    private var item : Item
    
    init(item : Item) {
        self.item = item
        super.init(style: .plain)
        
        self.headerView.item = item

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        configureNav()
    }
    
    //MARK: - UI
    
    override func configureNav() {
        super.configureNav()
        navigationItem.title = "Edit Item"
        
        
    }
    
    
    override func enableImageButton(imageArray: [UIImage]) {
        
        for i in 0 ..< item.imageLinks.count {
            headerView.buttons[i].isEnabled = true
        }
        
        
        let enableButtonCount = self.item.imageLinks.count
        headerView.buttons[enableButtonCount].isEnabled = true
        headerView.buttons[enableButtonCount].setTitleColor(.cyan, for: .normal)
    }
    
    //MARK: - Actions
    
    override func handleDone() {
        print("Done")
    }
    
    
    //MARK: - AddItem Cell Delegate

    // TODO: - swift not supprted Extension Procotol method (For EditItemVM)

    
    override func updateItemInfo(cell: AddItemCell, value: String, section: itemtemSections) {
        switch section {
        
         case .name:
            item.name = value
         case .description:
             return
         }
        
        print(item.name)
    }
    
    override func updateDescription(cell: AddItemCell, description: String) {
        item.description = description
        
        print(item.description)
    }
}

//MARK: -TableView Delegate

extension EditItemViewController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifer, for: indexPath) as! AddItemCell
        
        guard let section = itemtemSections(rawValue: indexPath.section) else {return cell}
        let viewModel = EditItemViewModel(item: item, section: section)
        
        cell.delegate = self
        cell.editItemVM = viewModel
        return cell
    }
    

}

