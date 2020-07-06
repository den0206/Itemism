//
//  File.swift
//  Itemism
//
//  Created by 酒井ゆうき on 2020/07/03.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit

private let reuseIdentifer = "AddItemCell"

protocol EditItemViewControllerDelegate : class {
    func compDelete(item : Item)
}

class EditItemViewController : AddItemViewController {
    
    //MARK: - Propert
    private var item : Item
    private var changeImageDictionary = [Int : UIImage]()
    private var isEdit = false
    
    weak var delegate : EditItemViewControllerDelegate?
    
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
        
        var enableButtonCount = item.imageLinks.count
        
        if item.imageLinks.count >= 3 {
            enableButtonCount = item.imageLinks.count - 1
        }
        
        for i in 0 ..< enableButtonCount {
            headerView.buttons[i].isEnabled = true
        }


        headerView.buttons[enableButtonCount].isEnabled = true
        headerView.buttons[enableButtonCount].setTitleColor(.cyan, for: .normal)
    }
    
    //MARK: - Actions
    
    override func handleDone() {
        
        view.endEditing(true)
        
        self.navigationController?.showPresentLoadindView(true)
        
        guard isEdit == true else {
            showAlert(title: "Recheck", message: "変更がありません")
            self.navigationController?.showPresentLoadindView(false)
            
            return
            
        }
        
        checkInternetConnection(nav: navigationController)
        
        uploadImages(imageDic: changeImageDictionary, item: item) { (item) in
            
            print(item)
            updateItemToFireStore(item: item) { (error) in
                
                if error != nil {
                    self.showAlert(title: "Error", message: error!.localizedDescription)
                    self.navigationController?.showPresentLoadindView(false)
                    
                    return
                }
                
                self.navigationController?.showPresentLoadindView(false)
                
                self.dismiss(animated: true, completion: {
                    self.delegate?.compDelete(item: item)
                })
            }
        }
        
    }
    
    
    //MARK: - AddItem Cell Delegate

    // TODO: - swift not supprted Extension Procotol method (For EditItemVM)

    
    override func updateItemInfo(cell: AddItemCell, value: String, section: itemtemSections) {
        switch section {
            
        case .name:
            item.name = value
            isEdit = true
        case .description:
            return
        }
    }
    
    override func updateDescription(cell: AddItemCell, description: String) {
        item.description = description
        isEdit = true
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
//
extension EditItemViewController {
    
    override func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else {return}
        
        
        headerView.buttons[imageIndex].setImage(selectedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        
        self.changeImageDictionary[imageIndex] = selectedImage
        
        if imageIndex != 2 {
            headerView.buttons[imageIndex + 1].isEnabled = true
            headerView.buttons[imageIndex + 1].setTitleColor(.cyan, for: .normal)
        }
        
        isEdit = true
        
        dismiss(animated: true, completion: nil)
        
        print(changeImageDictionary)
        //        print(changeImageDictionary.keys.sorted())
        
    }
}

