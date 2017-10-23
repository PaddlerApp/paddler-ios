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
    
    private var firUser: User?
    
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
    
    var fullname: String? {
        get {
            return firstName! + " " + lastName!
        }
    }

    init(from: DocumentSnapshot) {
        super.init()
        self.id = from.documentID
        setData(with: from.data())
    }
    
    init(from: User) {
        firUser = from
        super.init()
    }
    
    init(id: String, dictionary: [String: Any]) {
        super.init()
        self.id = id
        setData(with: dictionary)
    }
    
    func fetch(completion: @escaping () -> ()) {
        FirebaseClient.sharedInstance.saveUser(from: self.firUser!) { (data) in
            self.id = self.firUser!.uid
            self.setData(with: data)
            completion()
        }
    }
    
    private func setData(with: [String: Any]) {
        if let firstName = with["first_name"] as? String {
            self.firstName = firstName
        }
        if let lastName = with["last_name"] as? String {
            self.lastName = lastName
        }
        if let email = with["email"] as? String {
            self.email = email
        }
        if let profileString = with["profile_image_url"] as? String {
            self.profileURL = URL(string: profileString)
        }
        if let winCount = with["win_count"] as? Int {
            self.winCount = winCount
        }
        if let lossCount = with["loss_count"] as? Int {
            self.lossCount = lossCount
        }
    }
    
    func serialize() -> [String : Any] {
        var dict = [String : Any]()
        if let firstName = self.firstName {
            dict["first_name"] = firstName
        }
        if let lastName = self.lastName {
            dict["last_name"] = lastName
        }
        if let email = self.email {
            dict["email"] = email
        }
        if let profileString = self.profileURL {
            dict["profile_image_url"] = profileString.absoluteString
        }
        if let winCount = self.winCount {
            dict["win_count"] = winCount
        }
        if let lossCount = self.lossCount {
            dict["loss_count"] = lossCount
        }
        return dict
    }
    
    func getMatches(completion: @escaping ([Match]) -> ()) {
        var matches: [Match] = []
        FirebaseClient.sharedInstance.getMatches(forUser: self) { (docs) in
            for doc in docs {
                matches.append(Match(from: doc))
            }
            matches.sort(by: { (match, other) -> Bool in
                return match.createdAt! > other.createdAt!
            })
            completion(matches)
        }
    }
    
    func hasInitiatedRequest(completion: @escaping (Request?) -> ()) {
        FirebaseClient.sharedInstance.getInitiatedRequest(forUser: self) { (document) in
            if let document = document {
                completion(Request(from: document))
            } else {
                completion(nil)
            }
        }
    }
    
    func hasOpenRequest(completion: @escaping (Request?) -> ()) {
        FirebaseClient.sharedInstance.getOpenRequests { (documents) in
            for document in documents {
                let request = Request(from: document)
                if request.requesteeID == self.id || request.requesteeID == "" {
                    completion(Request(from: document))
                    return
                }
            }
            completion(nil)
        }
    }
    
    func addToken() {
        FirebaseClient.sharedInstance.addToken(forUser: self)
    }
    
    class func leaderboard(completion: @escaping ([PaddlerUser]) -> ()) {
        var users: [PaddlerUser] = []
        FirebaseClient.sharedInstance.getUsers { (documents) in
            for document in documents {
                users.append(PaddlerUser(from: document))
            }
            completion(users)
        }
    }
    
    class func contacts(completion: @escaping ([PaddlerUser]) -> ()) {
        var users: [PaddlerUser] = []
        FirebaseClient.sharedInstance.getContacts { (documents) in
            let current = PaddlerUser.current!
            for document in documents {
                if current.id != document.documentID {
                    users.append(PaddlerUser(from: document))
                }
            }
            completion(users)
        }
    }
}
