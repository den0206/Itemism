//
//  Downloader.swift
//  Itemism
//
//  Created by 酒井ゆうき on 2020/06/21.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit
import FirebaseStorage

func downloadImageFromData(picturedata : String) -> UIImage?{
    let imageFileName = (picturedata.components(separatedBy: "%").last!).components(separatedBy: "?").first!
    
    if fileExistPath(path: imageFileName) {
        // exist cache
        
        if let contentsOfFile = UIImage(contentsOfFile: fileInDocumentDictionary(filename: imageFileName)) {
            
             return contentsOfFile
        } else {
            print("No Cache")
            return nil
        }
        
    } else {
        // no cache
        
        let data = NSData(base64Encoded: imageFileName, options: NSData.Base64DecodingOptions(rawValue: 0))
        
        if data != nil {
            
            // for cache
            var docUrl = getDocumentUrl()
            
            docUrl = docUrl.appendingPathComponent(imageFileName, isDirectory: false)
            data!.write(to: docUrl, atomically: true)
            
            //
            
            return UIImage(data: data! as Data)
        } else {
            print("No Image")
            return nil
        }
        
    }

}

func downLoadImageFromUrl(imageLink : String) -> UIImage?{
    let imageUrl = NSURL(string: imageLink)
    
    let imageCasch = NSCache<NSString, UIImage>()
    
    
    if let imageFromCash = imageCasch.object(forKey: imageLink as NSString) {
        print("already")
        return imageFromCash
    }
    
    print(imageCasch)
    
    let nsData = NSData(contentsOf: imageUrl! as URL)
    
    let imageToreturn = UIImage(data: nsData! as Data)
    imageCasch.setObject(imageToreturn!, forKey: imageLink as NSString)
    
    return imageToreturn
    
    
//    let imageFileName = (imageLink.components(separatedBy: "%").last!).components(separatedBy: "?").first!
//
//    // check Exist
//    if fileExistPath(path: imageLink) {
//
//        print("Exist")
//        if let componentsFile = UIImage(contentsOfFile: fileInDocumentDictionary(filename: imageFileName)) {
//            return componentsFile
//        } else {
//            return nil
//        }
//    } else {
//        let nsData = NSData(contentsOf: imageUrl! as URL)
//
//        if nsData != nil {
//            // add To documentsUrl
//            var docURL = getDocumentUrl()
//
//            docURL = docURL.appendingPathComponent(imageFileName, isDirectory: false)
//            nsData!.write(to: docURL, atomically: true)
//
//            let imageToReturn = UIImage(data: nsData! as Data)
//            return imageToReturn
//
//        } else {
//            print("No Image Database")
//            return nil
//        }
//    }

    
}

func getDocumentUrl() -> URL {
    let documentUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last
    return documentUrl!
}


func fileInDocumentDictionary(filename : String) -> String{
    let fileUrl = getDocumentUrl().appendingPathComponent(filename)
    
    return fileUrl.path
}

func fileExistPath(path : String) -> Bool {
    var exist : Bool
    
    let filePath = fileInDocumentDictionary(filename: path)
    let fileManager = FileManager.default
    
    if fileManager.fileExists(atPath: filePath) {
        exist = true
    } else {
        exist = false
    }
    
    return exist
    
}


//MARK: - upload ItemImages

/// for new
func uploadItemImages(images : [UIImage?], itemId : String, completion : @escaping(_ imageLinks : [String]) -> Void) {
    
    if Reachabilty.HasConnection() {
        
        var uploadImagesCount = 0
        var imageLinkArray : [String] = []
        var nameShuffix = 0
        
        for image in images {
            let fileName = "ItemImages/" + itemId + "/" + "\(nameShuffix)" + ".jpg"
            let imageData = image!.jpegData(compressionQuality: 0.3)
            
            savaImageInFirestore(imageData: imageData!, fileName: fileName) { (imageLink) in
                
                if imageLink != nil {
                    imageLinkArray.append(imageLink!)
                    uploadImagesCount += 1
                    
                    if uploadImagesCount == images.count {
                        completion(imageLinkArray)
                    }
                }
            }
            
            nameShuffix += 1
        }
        
    } else {
        print("No Internet Connections")
    }
}


/// for edit
func uploadItemImages(imageDic : [Int : UIImage], item : Item, completion :  @escaping(Item) -> Void) {
    
    var item = item
    
    var uploadImageCount = 0
    let sortedKeys = imageDic.keys.sorted()
    
    for key in sortedKeys {
        /// UIImage
        let fileName =  "ItemImages/" + item.id + "/" + "\(key)" + ".jpg"
        let imageData = imageDic[key]?.jpegData(compressionQuality: 0.3)
        
        
        savaImageInFirestore(imageData: imageData!, fileName: fileName) { (imageLink) in
            
            if imageLink != nil {
                
                /// delete if exist index
                if item.imageLinks.indices.contains(key) {
                    item.imageLinks.remove(at: key)
                }
                
                item.imageLinks.insert(imageLink!, at: key)
                uploadImageCount += 1
                
                if uploadImageCount == sortedKeys.count {
                    completion(item)
                }
            }
        }
        
    }
}

//MARK: - upload Message Pic

func uploadMessageImage(image : UIImage?, chatRoomId : String,completion :  @escaping(String?) -> Void) {
    
    let dateString = dateFormatter().string(from: Date())
    let photoFileName = "PictureMessages/" + User.currentId() + "/" + chatRoomId + "/" + dateString + ".jpg"
    
    guard let imageData = image?.jpegData(compressionQuality: 0.3) else {
        completion(nil)
        return }
    
    savaImageInFirestore(imageData: imageData, fileName: photoFileName) { (imageLink) in
        completion(imageLink)
        
        
    }
    
}

func savaImageInFirestore(imageData : Data,fileName : String,completion :  @escaping(_ imageLink : String?) -> Void) {
    
    let storage = Storage.storage()

    
    var task : StorageUploadTask!
    let storogeRef = storage.reference(forURL: kFILEREFERENCE).child(fileName)
    
    task = storogeRef.putData(imageData, metadata: nil, completion: { (meta, error) in
        
        task.removeAllObservers()
        
        if error != nil {
            print(error!.localizedDescription)
            completion(nil)
            return
        }
        
        storogeRef.downloadURL { (url, error) in
            
            guard let downloadUrl = url else {
                completion(nil)
                return
            }
            completion(downloadUrl.absoluteString)
        }
    })
}
