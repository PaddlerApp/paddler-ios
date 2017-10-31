//
//  Constants.swift
//  Paddler
//
//  Created by Prithvi Prabahar on 10/29/17.
//  Copyright © 2017 Paddler. All rights reserved.
//

import UIKit

struct Constants {
    static let buttonOrangeBackground = UIColor(red: 255/255, green: 224/255, blue: 178/255, alpha: 1.0)
    static let buttonOrangeBorder = UIColor(red:1.00, green:0.80, blue:0.50, alpha:1.0)
    static let buttonOrangeTint = UIColor(red: 239/255, green: 108/255, blue: 0.0, alpha: 1.0)
    
    static let buttonGreenBackground = UIColor(red: 31/255, green: 202/255, blue: 106/255, alpha: 1.0)
    
    static let buttonAnimationDuration = 0.7
    static let buttonCornerRadius: CGFloat = 5.0
    
    static let matchToLive = "myMatchesToLiveMatchSegue"
    static let contactToLive = "contactsToLiveMatchSegue"
    static let matchCellIdentifier = "matchCell"
    static let contactCellIdentifier = "contactCell"
    
    static let requestMatchString = "Request Match"
    static let pendingMatchString = "Request Pending"
    
    static let placeholderImageString = "people-placeholder.png"
    static let orangeImageString = "orange-image"
    
    static let myMatchesNavigationControllerString = "MyMatchesNavigationController"
    static let leaderboardNavigationControllerString = "LeaderboardNavigationController"
    static let contactsNavigationControllerString = "ContactsNavigationController"
    static let profileNavigationControllerString = "ProfileNavigationController"
    
    static let matchesItem = "My Matches"
    static let leaderboardItem = "Leaderboard"
    static let contactsItem = "Contacts"
    static let profileItem = "Profile"
}

enum RequestState: Int {
    case NO_REQUEST = 0, HAS_OPEN_REQUEST, REQUEST_PENDING, REQUEST_ACCEPTED
}
