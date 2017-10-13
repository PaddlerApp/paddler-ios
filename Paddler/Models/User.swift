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

extension User {
    
    static var _current: User?
    
    class var current: User? {
        get {
            if _current == nil {
                _current = Auth.auth().currentUser
            }
            
            return _current
        }
    }
    
    var firstName: String? {
        get {
            let first = displayName?.split(separator: " ", maxSplits: 1)
            return String(describing: first![0])
        }
    }
    
    var lastName: String? {
        get {
            let last = displayName?.split(separator: " ", maxSplits: 1)
            return String(describing: last![1])
        }
    }
}
