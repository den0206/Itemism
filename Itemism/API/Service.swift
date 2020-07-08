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

//MARK: - ITEM Service

class ItemService {
    
    static func fetchAllItems( completion : @escaping([Item]) -> Void) {
        
        firebaseReference(.Item).order(by: kTIMESTAMP, descending: true
        ).getDocuments { (snapshot, error) in
            
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
    
    static func fetchItem(itemId : String, completion :  @escaping(Item) -> Void) {
        
        firebaseReference(.Item).document(itemId).getDocument { (snapshot, error) in
            
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            
            guard let snapshot = snapshot else {return}
            
            if snapshot.exists {
                let dic = snapshot.data()!
                let uid = dic[kUSERID] as! String
                
                var item = Item(dictionry: dic)
                
                UserService.fetchUser(uid: uid) { (user) in
                    item.user = user
                    completion(item)
                }
                
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
    
    //MARK: - Add Wants
    
    static func checkWanted(item : Item, completion : @escaping(_ wanted : Bool) -> Void) {
        
        guard User.currentId() != item.userId else {
            completion(false)
            return
        }
        
        let itemId = item.id

        firebaseReference(.Item).document(itemId).collection(kWANT).document(User.currentId()).getDocument { (snapshot, error) in
            guard let snapshot = snapshot else {
                completion(false)
                return
            }
            
            if snapshot.exists {
                completion(true)
            } else {
                completion(false)
            }
        }
        
        
    }
    
    static func wantItem(item : Item, wanted : Bool,completion : @escaping(Error?) -> Void) {
        
        guard User.currentId() != item.userId else {
            return
        }
        
        
        let itemId = item.id
        let currentUserId = User.currentId()
        
        if !wanted {
            let value = [kITEMID : itemId,
                         kOWNERID : item.userId,
                         kUSERID : currentUserId,
                         kTIMESTAMP : Timestamp(date: Date())] as [String : Any]
            
            firebaseReference(.Item).document(itemId).collection(kWANT).document(currentUserId).setData(value) { (error) in
                completion(error)
            }
        } else {
            firebaseReference(.Item).document(itemId).collection(kWANT).document(currentUserId).delete(completion: completion)
        }
        
        
        
    }
    
    
    
    //MARK: - Delete & Edit Items
    
    static func deleteItem(itemId : String, completion :  @escaping(Error?) -> Void) {
        
        firebaseReference(.Item).document(itemId).delete(completion: completion)
        
        // TODO: - delete image from storoge
        
        let strogeRef = Storage.storage().reference()
        strogeRef.child("ItemImages").child(itemId).listAll { (result, error) in
            if error != nil {
                completion(error)
                return
            }
            
            for ref in result.items {
                ref.delete { (error) in
                    
                    if error != nil {
                        completion(error)
                        return
                    }
                    
                    print("Delete")
                }
            }
            
        }

    }
    
}

//MARK: - Item fetch Wants

extension ItemService {
    
    static func fetchUserWants(user : User, completion : @escaping([Item]) -> Void) {
        /// sub collection
        
        
        
        Firestore.firestore().collectionGroup(kWANT).whereField(kUSERID, isEqualTo: user.uid).getDocuments { (snapshopt, error) in
            
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            
            guard let snapshopt = snapshopt else {return}
            
            var items = [Item]()
            
            if !snapshopt.isEmpty {
                snapshopt.documents.forEach({ (document) in
                    let dic = document.data()
                    let itemId = dic[kITEMID] as! String
                    
                    ItemService.fetchItem(itemId: itemId) { (item) in
                        var item = item
                        item.wanted = true
                        
                        items.append(item)
                        
                        if snapshopt.documents.count == items.count {
                            completion(items)
                        }
                        
                    }
                })
            } else {
                completion(items)
            }
            
        }
        
    }
    
}

//MARK: - Fetch Request

extension ItemService {
    
    static func fetchRequest(user : User, completion : @escaping([Request]) -> Void) {
        
        Firestore.firestore().collectionGroup(kWANT).whereField(kOWNERID, isEqualTo: user.uid).getDocuments { (snapshot, error) in
            
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            guard let snapshot = snapshot else {return}
            
            var requests = [Request]()
            
            if !snapshot.isEmpty {
                snapshot.documents.forEach { (document) in
                    let doc = document.data()
                    
                    /// except Current user
                    guard user.uid == doc[kOWNERID] as? String else {return}
                    let itemId = doc[kITEMID] as! String
                    let userID = doc[kUSERID] as! String
                    
                    ItemService.fetchItem(itemId: itemId) { (item) in
                        var item = item
                        item.user = User.currentUser()
                        
                        UserService.fetchUser(uid: userID) { (requestUser) in
                            let request = Request(item: item, requestUser: requestUser, message: nil)
                            
                            requests.append(request)
                            if snapshot.documents.count == requests.count {
                                completion(requests)
                            }
                        }
                    }
                    
                }
            } else {
                completion(requests)
            }
        }
        
    }
}
