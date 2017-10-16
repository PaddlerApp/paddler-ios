//
//  Request.swift
//  Paddler
//
//  Created by Prithvi Prabahar on 10/14/17.
//  Copyright © 2017 Paddler. All rights reserved.
//

import Foundation
import Firebase

class Request: NSObject {
    
    var id: String?
    var requestorID: String?
    var requesteeID: String?
    var requestor: PaddlerUser?
    var requestee: PaddlerUser?
    var status: String?
    var isDirect: Bool?
    var createdAt: Date?
    
    class func createDirect(with: PaddlerUser) -> Request {
        let req = Request()
        req.requestorID = PaddlerUser.current!.id
        req.requesteeID = with.id!
        req.requestor = PaddlerUser.current!
        req.requestee = with
        req.status = "open"
        req.isDirect = true
        req.createdAt = Date()
        req.id = FirebaseClient.sharedInstance.save(request: req)
        return req
    }
    
    class func createBroadcast() -> Request {
        let req = Request()
        req.requestorID = PaddlerUser.current!.id
        req.requesteeID = ""
        req.requestor = PaddlerUser.current!
        req.status = "open"
        req.isDirect = false
        req.createdAt = Date()
        req.id = FirebaseClient.sharedInstance.save(request: req)
        return req
    }
    
    init(from: DocumentSnapshot) {
        super.init()
        self.id = from.documentID
        if let requestorID = from["requestor_id"] as? String {
            self.requestorID = requestorID
        }
        if let requesteeID = from["requestee_id"] as? String {
            self.requesteeID = requesteeID
        }
        if let status = from["status"] as? String {
            self.status = status
        }
        if let isDirect = from["isDirect"] as? Bool {
            self.isDirect = isDirect
        }
        if let createdAt = from["created_at"] as? Date {
            self.createdAt = createdAt
        }
        if let requestorDict = from["requestor"] as? [String: Any] {
            self.requestor = PaddlerUser(id: requestorID!, dictionary: requestorDict)
        }
        if let requesteeDict = from["requestee"] as? [String: Any] {
            self.requestee = PaddlerUser(id: requesteeID!, dictionary: requesteeDict)
        }
    }
    
    override init() {
        super.init()
    }
    
    func cancel() {
        self.status = "closed"
        FirebaseClient.sharedInstance.close(request: self)
    }
    
    func accept() -> Match {
        self.status = "closed"
        let user = PaddlerUser.current!
        self.requesteeID = user.id
        self.requestee = user
        FirebaseClient.sharedInstance.close(request: self)
        return Match(from: self)
    }
}
