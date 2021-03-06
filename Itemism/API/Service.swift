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
            
           setUserDefaults(values: values, key: kCURRENTUSER)
            
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
                //
                //                UserDefaults.standard.setValue(snapshot.data()! as [String : Any], forKey: kCURRENTUSER)
                //                UserDefaults.standard.synchronize()
                //
                setUserDefaults(values: snapshot.data()! as [String : Any], key: kCURRENTUSER)
                
                
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
    
    static func updateUser(user : User, completion :  @escaping(Error?) -> Void) {
        
        guard user.uid == User.currentId() else {return}
        
        let data = [kPROFILE_IMAGE : user.profileImageData,
                    kFULLNAME : user.name,
                    kBIO : user.bio]
        
        firebaseReference(.User).document(user.uid).updateData(data, completion: completion)
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
            var currentItemsCount = 0
            //            var itemsCount = 0
            
            if !snapshot.isEmpty {
                for doc in snapshot.documents {
                    let dic = doc.data()
                    var item = Item(dictionry: dic)
                    
                    /// anoid curentUser Item
                    guard User.currentId() != item.userId else {
                        currentItemsCount += 1
                        continue}
                    
                    UserService.fetchUser(uid: item.userId) { (user) in
                        item.user = user
                        items.append(item)
                        
                        if items.count == snapshot.documents.count - currentItemsCount{
                            completion(items)
                        }
                    }
                }
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

//MARK: - Match

class MatchService {
    
    static func checkMatchExist(user : User, completion : @escaping(Bool) -> Void) {
        
        firebaseReference(.Match).document(User.currentId()).collection(kMATCHES).document(user.uid).getDocument { (snapshot, error) in
            
            guard let snapshot = snapshot else {return }
            
            completion(snapshot.exists)
            
            
        }
    }
    
    static func fetchMatch(comletion :  @escaping([Match]) -> Void) {
        
        firebaseReference(.Match).document(User.currentId()).collection(kMATCHES).getDocuments { (snapshot, error) in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            
            guard let snapshot = snapshot else {return}
            
            let matches = snapshot.documents.map({Match(dictionary: $0.data())})
            comletion(matches)
        }
    }
    

    
    static func uploadMatch(currentUser : User, mathedUser : User) {
        let matchedUserDate = [ kUSERID : mathedUser.uid,
                                kFULLNAME : mathedUser.name,
                                kPROFILE_IMAGE : mathedUser.profileImageData
        ]
        
        firebaseReference(.Match).document(currentUser.uid).collection(kMATCHES).document(mathedUser.uid).setData(matchedUserDate)
        
        /// add matchUser DB
        
        let currentUserDate = [ kUSERID : currentUser.uid,
                                kFULLNAME : currentUser.name,
                                kPROFILE_IMAGE : currentUser.profileImageData
        ]
        
        firebaseReference(.Match).document(mathedUser.uid).collection(kMATCHES).document(currentUser.uid).setData(currentUserDate)
    }
}


//MARK: - MessageService

class MessageService {
    
    static func fetchRecent(userId : String, completion :  @escaping([Dictionary<String, Any>]) -> Void) -> ListenerRegistration?{
        
        return firebaseReference(.Recent).whereField(kUSERID, isEqualTo: userId).order(by: kDATE, descending: true).addSnapshotListener { (snapshot, error) in
            
            guard let snapshot = snapshot else {return}
            
            var recents = [[String : Any]]()
            
            if !snapshot.isEmpty {
                snapshot.documents.forEach { (doc) in
                    
                    let recent = doc.data()
                    
                    if recent[kLASTMESSAGE] as! String != "" && recent[kCHATROOMID] != nil && recent[kRECENTID] != nil {
                        recents.append(recent)
                    }
                    
                }
                
                completion(recents)
            } else {
                
                //// empty
                completion(recents)
            }
            
        }
        
    }
    
    

    //MARK: - No Use

    static func downloaduserMatches(completion :  @escaping([String]) -> Void) {
        /// only last MOnt
        let lastMonth = Calendar.current.date(byAdding: .month, value: -1, to: Date()) ?? Date()
        
        firebaseReference(.Match).whereField(kMESSAGEID, arrayContains: User.currentId()).whereField(kDATE, isGreaterThan: lastMonth).order(by: kDATE, descending: true).getDocuments { (snapshot, error) in
            
            var allmatchesIds = [String]()
            
            guard let snapshot = snapshot else {return}
            if !snapshot.isEmpty {
                snapshot.documents.forEach({ (document) in
                    
                    allmatchesIds += document[kMESSAGEID] as? [String] ?? [""]
                    
                    completion(removeCurrentUserIDFrom(userIds: allmatchesIds))
                })
            }
        }
    }

}


