//
//  MyMatchesViewController.swift
//  Paddler
//
//  Created by YingYing Zhang on 10/10/17.
//  Copyright © 2017 Paddler. All rights reserved.
//

import UIKit

class MyMatchesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        PaddlerUser.current!.getMatches { (matches) in
            for match in matches {
                print(match.createdAt!)
            }
        }
        
        let profileNavVC = tabBarController?.viewControllers![3] as! UINavigationController
        let profileVC = profileNavVC.viewControllers[0] as! ProfileViewController
        profileVC.broadcastRequest = Request.createBroadcast()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
