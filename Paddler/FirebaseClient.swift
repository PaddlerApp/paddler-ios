//
//  FirebaseClient.swift
//  Paddler
//
//  Created by Prithvi Prabahar on 10/12/17.
//  Copyright © 2017 Paddler. All rights reserved.
//

import Foundation
import Firebase
import GoogleSignIn

class FirebaseClient: NSObject {
    
    static let sharedInstance = FirebaseClient()
    
    private var db: Firestore
    private var users: CollectionReference
    private var matches: CollectionReference
    private var requests: CollectionReference
    
    override init() {
        db = Firestore.firestore()
        users = db.collection("users")
        matches = db.collection("matches")
        requests = db.collection("requests")
        super.init()
    }
    
    func getUsers() {
        users.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                }
            }
        }
    }
    
    func saveUser(from: User, completion: @escaping ([String : Any]) -> ()) {
        let userRef = users.document(from.uid)
        
        userRef.getDocument(completion: { (document, error) in
            var userData: [String: Any] = [:]
            if document != nil && (document?.exists)! {
                userData = document!.data()
            } else {
                let splitName = from.displayName?.split(separator: " ", maxSplits: 1)
                userData = [
                    "first_name": splitName![0],
                    "last_name": splitName![1],
                    "win_count": 0,
                    "loss_count": 0,
                    "profile_image_url": from.photoURL!.absoluteString,
                    "email": from.email!
                ]
                userRef.setData(userData)
            }
            completion(userData)
        })
    }
}
