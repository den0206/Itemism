//
//  FirebaseReferences.swift
//  Itemism
//
//  Created by 酒井ゆうき on 2020/06/21.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//


import FirebaseFirestore

enum References : String {
    case User
    case Item
    case Match
    case Recent
    case Message
}

func firebaseReference(_ reference : References) -> CollectionReference {
    return Firestore.firestore().collection(reference.rawValue)
}
