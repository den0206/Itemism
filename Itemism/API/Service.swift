//
//  Service.swift
//  Itemism
//
//  Created by 酒井ゆうき on 2020/06/21.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import Foundation
import Firebase

//MARK: - Authentification

struct AuthCredential {
    
    let email : String
    let fullname : String
    let password : String
    let profileImage : String
    
    
}


class AuthService {
    
    static func registerser(credential : AuthCredential, completion :  @escaping(Error?) -> Void) {
        
        Auth.auth().createUser(withEmail: credential.email, password: credential.password) { (result, error) in
            
            if error != nil {
                completion(error)
                return
            }
            
            guard let uid = result?.user.uid else {return}
            
            let values  = [kEMAIL : credential.email,
                           kFULLNAME : credential.fullname,
                           kPROFILE_IMAGE : credential.profileImage,
                           kUSERID : uid] as [String : Any]
            
            UserDefaults.standard.setValue(values, forKey: kCURRENTUSER)
            UserDefaults.standard.synchronize()
            
            firebaseReference(.User).document(uid).setData(values, completion: completion)
            
        }
        
        
        
    }
    
    static func loginUser(email : String, password : String, complation : AuthDataResultCallback?) {
        
        Auth.auth().signIn(withEmail: email, password: password, completion: complation)
    }
    
    
    static func fetchCurrentUser(uid : String, completion : @escaping(User) -> Void) {
        
        firebaseReference(.User).document(uid).getDocument { (snapshot, error) in
            
            guard let snapshot = snapshot else {return}
            
            if snapshot.exists {
                let dictionary = snapshot.data()!
                
                UserDefaults.standard.setValue(snapshot.data()! as [String : Any], forKey: kCURRENTUSER)
                UserDefaults.standard.synchronize()
                
                   let user = User(dictionary: dictionary)
                   completion(user)
            }
        }
        
    }
    
}

//MARK: - User Service

class UserService {
    
    static func fetchUser(uid : String, completion :  @escaping(User) -> Void) {
        
        firebaseReference(.User).document(uid).getDocument { (snapshot, error) in
            
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            
            guard let snapshot = snapshot else {return}
            
            if snapshot.exists {
                let date = snapshot.data()
                let user = User(dictionary: date!)
                
                completion(user)
            }
        }
    }
}

//MARK: - ITRM Service

class ItemService {
    
    static func fetchAllItems( completion : @escaping([Item]) -> Void) {
        
        firebaseReference(.Item).order(by: kTIMESTAMP, descending: false).getDocuments { (snapshot, error) in
            
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            
            guard let snapshot = snapshot else {return}
            
            var items = [Item]()
//            var itemsCount = 0
            
            if !snapshot.isEmpty {
                let documents = snapshot.documents
                
                documents.forEach { (snapshot) in
                    let document = snapshot.data()
                    var item = Item(dictionry: document)
                    
                    /// add user objc
                    UserService.fetchUser(uid: item.userId) { (user) in
                        
                        item.user = user
                        
                        items.append(item)
                        
                        if items.count == documents.count {
                            print("Set")
                            completion(items)
                        }
                    }


                }
//                completion(items)
            }
        }
        
    }
    
    
    static func fetchUserItems(user : User, completion :  @escaping([Item]) -> Void) {
        
        firebaseReference(.Item).whereField(kUSERID, isEqualTo: user.uid).order(by: kTIMESTAMP, descending: false).getDocuments { (snapshot, error) in
            
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            
            guard let snapshot = snapshot else {return}
            
            var items = [Item]()
            if !snapshot.isEmpty {
               
                
                snapshot.documents.forEach { (document) in
                    var item = Item(dictionry: document.data())
                    
                    /// set user property
                    item.user = user
                    
                    items.append(item)
                    
                    if snapshot.documents.count == items.count {
                        completion(items)
                    }
                }
            } else {
                print("No Item")
                completion(items)
            }
        }
    }
    
    
    //MARK: - Delete & Edit Items
    
    static func deleteItem(itemId : String, completion :  @escaping(Error?) -> Void) {
        
        firebaseReference(.Item).document(itemId).delete(completion: completion)
        
        // TODO: - delete from storoge

    }
    
}


