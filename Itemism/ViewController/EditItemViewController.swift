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
    private var changeImageDictionary = [Int : UIImage]()
    private var isEdit = false
    
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
        view.endEditing(true)
        
        uploadImages(imageDic: changeImageDictionary, item: item) { (item) in
            
            print(item)
            
            /// save firestore
        }
        
//        var uploadImageCount = 0
//        let sortedKeys = changeImageDictionary.keys.sorted()
//
//        for key in sortedKeys {
//            /// UIImage
//            let fileName =  "ItemImages/" + item.id + "/" + "\(key)" + ".jpg"
//            let imageData = changeImageDictionary[key]?.jpegData(compressionQuality: 0.3)
//
//
//            savaImageInFirestore(imageData: imageData!, fileName: fileName) { (imageLink) in
//
//                if imageLink != nil {
//                    self.item.imageLinks.insert(imageLink!, at: key)
//                    uploadImageCount += 1
//
//                    if uploadImageCount == sortedKeys.count {
//                        print(self.item)
//                        /// completion(item)
//                    }
//                }
//            }
//
//        }

//        for (imageIndex,image) in changeImageDictionary {
//            print(imageIndex,image)
//        }
        
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
        
        enableImageButton(imageArray: itemImages)
        isEdit = true
        
        dismiss(animated: true, completion: nil)
        
        print(changeImageDictionary)
        //        print(changeImageDictionary.keys.sorted())
        
    }
}

