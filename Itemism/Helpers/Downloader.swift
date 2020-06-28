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

func uploadImages(images : [UIImage?], itemId : String, completion : @escaping(_ imageLinks : [String]) -> Void) {
    
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
