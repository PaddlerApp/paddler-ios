//
//  Match.swift
//  Paddler
//
//  Created by Prithvi Prabahar on 10/13/17.
//  Copyright © 2017 Paddler. All rights reserved.
//

import Foundation
import Firebase

class Match: NSObject {
    
    var id: String?
    var createdAt: Date?
    var finishedAt: Date?
    var loserID: String?
    var winnerID: String?
    var requestorID: String?
    var requesteeID: String?
    var requestor: PaddlerUser?
    var requestee: PaddlerUser?
    var requestorScore: Int?
    var requesteeScore: Int?
    
    init(from: DocumentSnapshot) {
        super.init()
        self.id = from.documentID
        let data = from.data()
        if let createdAt = data["created_at"] as? Date {
            self.createdAt = createdAt
        }
        if let finishedAt = data["finished_at"] as? Date {
            self.finishedAt = finishedAt
        }
        if let loserID = data["loser_id"] as? String {
            self.loserID = loserID
        }
        if let winnerID = data["winner_id"] as? String {
            self.winnerID = winnerID
        }
        if let requestorID = data["requestor_id"] as? String {
            self.requestorID = requestorID
        }
        if let requesteeID = data["requestee_id"] as? String {
            self.requesteeID = requesteeID
        }
        if let requestorScore = data["requestor_score"] as? Int {
            self.requestorScore = requestorScore
        }
        if let requesteeScore = data["requestee_score"] as? Int {
            self.requesteeScore = requesteeScore
        }
        if let requestorDict = from["requestor"] as? [String: Any] {
            self.requestor = PaddlerUser(id: requestorID!, dictionary: requestorDict)
        }
        if let requesteeDict = from["requestee"] as? [String: Any] {
            self.requestee = PaddlerUser(id: requesteeID!, dictionary: requesteeDict)
        }
    }
    
    init(from: Request) {
        super.init()
        self.createdAt = Date()
        self.finishedAt = nil
        self.loserID = ""
        self.winnerID = ""
        self.requestorID = from.requestorID
        self.requesteeID = from.requesteeID
        self.requestor = from.requestor
        self.requestee = from.requestee
        self.requestorScore = 0
        self.requesteeScore = 0
        self.id = FirebaseClient.sharedInstance.save(match: self)
    }
    
    func finish(requestorScore: Int, andRequesteeScore: Int) {
        self.finishedAt = Date()
        self.requestorScore = requestorScore
        self.requesteeScore = andRequesteeScore
        
        if self.requestorScore! > self.requesteeScore! {
            self.winnerID = self.requestorID
            self.loserID = self.requesteeID
        } else {
            self.winnerID = self.requesteeID
            self.loserID = self.requestorID
        }
        FirebaseClient.sharedInstance.finish(match: self)
    }
    
    func cancel() {
        FirebaseClient.sharedInstance.cancel(match: self)
    }
    
    func onComplete(completion: @escaping () -> ()) {
        FirebaseClient.sharedInstance.onComplete(match: self) { (documentSnapshot) in
            if let document = documentSnapshot {
                if !document.exists {
                    completion()
                } else {
                    let match = Match(from: document)
                    if match.finishedAt != nil {
                        completion()
                    }
                }
            }
        }
    }
}
