//
//  AppDelegate.swift
//  Paddler
//
//  Created by Prithvi Prabahar on 10/9/17.
//  Copyright © 2017 Paddler. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let myMatchesNavigationController = storyboard.instantiateViewController(withIdentifier: "MyMatchesNavigationController") as! UINavigationController
        let myMatchesViewController = myMatchesNavigationController.topViewController as! MyMatchesViewController
        //myMatchesViewController.endpoint = "my_matches"
        
        let leaderboardNavigationController = storyboard.instantiateViewController(withIdentifier: "LeaderboardNavigationController") as! UINavigationController
        let leaderboardViewController = leaderboardNavigationController.topViewController as! LeaderboardViewController
        //leaderboardViewController.endpoint = "leaderboard"
        
        let contactsNavigationController = storyboard.instantiateViewController(withIdentifier: "ContactsNavigationController") as! UINavigationController
        let contactsViewController = contactsNavigationController.topViewController as! ContactsViewController
        //contactsViewController.endpoint = "contacts"
        
        let profileNavigationController = storyboard.instantiateViewController(withIdentifier: "ProfileNavigationController") as! UINavigationController
        let profileViewController = profileNavigationController.topViewController as! ProfileViewController
        //profileViewController.endpoint = "profile"
        
        
        myMatchesNavigationController.tabBarItem.title = "My Matches"
        //myMatchesNavigationController.tabBarItem.image = UIImage(named: "movie")
        leaderboardNavigationController.tabBarItem.title = "Leaderboard"
        //leaderboardNavigationController.tabBarItem.image = UIImage(named: "star")
        contactsNavigationController.tabBarItem.title = "Contacts"
        //contactsNavigationController.tabBarItem.image = UIImage(named: "star")
        profileNavigationController.tabBarItem.title = "Profile"
        //profileNavigationController.tabBarItem.image = UIImage(named: "star")
        
        let tabBarController = UITabBarController()
        
        tabBarController.viewControllers = [myMatchesNavigationController, leaderboardNavigationController, contactsNavigationController, profileNavigationController]
        
        tabBarController.selectedIndex = 0;
        
        tabBarController.tabBar.tintColor = UIColor(red:1.00, green:0.80, blue:0.40, alpha:1.0)
        tabBarController.tabBar.selectionIndicatorImage = nil
        //tabBarController.tabBar.unselectedItemTintColor = UIColor.white
        tabBarController.tabBar.isTranslucent = false
        tabBarController.tabBar.barTintColor = UIColor(red:0.40, green:0.06, blue:0.15, alpha:1.0)
        
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}
