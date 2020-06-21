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
    
    
    
}

//MARK: - API
