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
    var status: String?
    var isDirect: Bool?
    var createdAt: Date?
    
    class func createDirect(with: String) -> Request {
        let req = Request()
        req.requestorID = PaddlerUser.current!.id
        req.requesteeID = with
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
        req.status = "open"
        req.isDirect = false
        req.createdAt = Date()
        req.id = FirebaseClient.sharedInstance.save(request: req)
        return req
    }
    
    init(from: DocumentSnapshot) {
        super.init()
        self.id = from.documentID
        if let requestorID = from["requestor"] as? String {
            self.requestorID = requestorID
        }
        if let requesteeID = from["requestee"] as? String {
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
    }
    
    override init() {
        super.init()
    }
    
    func cancel() {
        self.status = "closed"
        FirebaseClient.sharedInstance.close(request: self)
    }
}
