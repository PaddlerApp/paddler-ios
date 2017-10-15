//
//  ProfileViewController.swift
//  Paddler
//
//  Created by YingYing Zhang on 10/10/17.
//  Copyright © 2017 Paddler. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var playerWinsLabel: UILabel!
    @IBOutlet weak var playerLossesLabel: UILabel!
    
    var broadcastRequest: Request?
    var directRequest: Request?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //print(PaddlerUser.current!.firstName!)
        let currentUser = PaddlerUser.current!
        
        let firstName = currentUser.firstName!
        let lastName = currentUser.lastName!
        let winCount = currentUser.winCount!
        let lossCount = currentUser.lossCount!
        
        if currentUser.profileURL != nil {
            let url = currentUser.profileURL
            let data = try? Data(contentsOf: url!)
            profileImageView.image = UIImage(data: data!)
            //.setImageWith(currentUser.imageURL!)
        } else {
            profileImageView.image = UIImage(named:"people-placeholder.png")
        }
        
        playerNameLabel.text = "\(firstName) \(lastName)"
        playerWinsLabel.text = "\(winCount)"
        playerLossesLabel.text = "\(lossCount)"
        
        if let request = broadcastRequest {
            request.cancel()
        }
        
        if let request = directRequest {
            request.cancel()
        }
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logOut(_ sender: UIButton) {
        GIDSignIn.sharedInstance().signOut()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = storyboard.instantiateInitialViewController()
        UIApplication.shared.keyWindow?.rootViewController = loginVC
    }

}
