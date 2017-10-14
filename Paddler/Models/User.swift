//
//  User.swift
//  Paddler
//
//  Created by Prithvi Prabahar on 10/11/17.
//  Copyright © 2017 Paddler. All rights reserved.
//

import Foundation
import Firebase
import GoogleSignIn

class PaddlerUser: NSObject {
    
    static var _current: PaddlerUser?
    
    var id: String?
    var firstName: String?
    var lastName: String?
    var email: String?
    var profileURL: URL?
    var winCount: Int?
    var lossCount: Int?
    
    class var current: PaddlerUser? {
        get {
            if _current == nil {
                if let user = Auth.auth().currentUser {
                    _current = PaddlerUser(from: user)
                }
            }
            return _current
        }
        set {
            _current = newValue
        }
    }
    
    init(from: [String: Any]) {
        super.init()
    }
    
    init(from: User) {
        super.init()
        FirebaseClient.sharedInstance.saveUser(from: from) { (data) in
            self.id = from.uid
            print(data)
            if let firstName = data["first_name"] as? String {
                self.firstName = firstName
            }
            if let lastName = data["last_name"] as? String {
                self.lastName = lastName
            }
            if let email = data["email"] as? String {
                self.email = email
            }
            if let profileString = data["profile_image_url"] as? String {
                self.profileURL = URL(string: profileString)
            }
            if let winCount = data["win_count"] as? Int {
                self.winCount = winCount
            }
            if let lossCount = data["loss_count"] as? Int {
                self.lossCount = lossCount
            }
        }
    }
}
