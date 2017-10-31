//
//  MyTabManViewController.swift
//  Paddler
//
//  Created by Prithvi Prabahar on 10/25/17.
//  Copyright © 2017 Paddler. All rights reserved.
//

import UIKit
import Tabman
import Pageboy

class MyTabManViewController: TabmanViewController, PageboyViewControllerDataSource {
    
    var viewControllers: [UIViewController]
    
    required init?(coder aDecoder: NSCoder) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myMatchesNavigationController = storyboard.instantiateViewController(withIdentifier: Constants.myMatchesNavigationControllerString) as! UINavigationController
        let leaderboardNavigationController = storyboard.instantiateViewController(withIdentifier: Constants.leaderboardNavigationControllerString) as! UINavigationController
        let contactsNavigationController = storyboard.instantiateViewController(withIdentifier: Constants.contactsNavigationControllerString) as! UINavigationController
        let profileNavigationController = storyboard.instantiateViewController(withIdentifier: Constants.profileNavigationControllerString) as! UINavigationController
        
        viewControllers = [myMatchesNavigationController, leaderboardNavigationController, contactsNavigationController, profileNavigationController]
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        
        // configure the bar
        self.bar.items = [Item(image: #imageLiteral(resourceName: "matches")),
                          Item(image: #imageLiteral(resourceName: "leaderboard")),
                          Item(image: #imageLiteral(resourceName: "contacts")),
                          Item(image: #imageLiteral(resourceName: "profile"))]
        
        self.bar.location = .bottom
        
        self.bar.appearance = TabmanBar.Appearance({ (appearance) in
            appearance.text.font = .systemFont(ofSize: 12.0)
            appearance.indicator.bounces = true
            appearance.layout.minimumItemWidth = self.view.frame.width/4
            appearance.layout.interItemSpacing = 0
            appearance.layout.edgeInset = 0
//            appearance.layout.height = TabmanBar.Height.explicit(value: 100)
        })
    }
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController,
                        at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }
    
}
