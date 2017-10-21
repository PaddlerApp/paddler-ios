//
//  MessageDelegate.swift
//  Paddler
//
//  Created by Prithvi Prabahar on 10/21/17.
//  Copyright © 2017 Paddler. All rights reserved.
//

import Foundation
import Firebase

class MessageDelegate: NSObject, MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        PaddlerUser.current!.addToken()
    }
}
