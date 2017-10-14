//
//  Request.swift
//  Paddler
//
//  Created by Prithvi Prabahar on 10/14/17.
//  Copyright © 2017 Paddler. All rights reserved.
//

import Foundation

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
    
    func cancel() {
        self.status = "closed"
        FirebaseClient.sharedInstance.close(request: self)
    }
}
