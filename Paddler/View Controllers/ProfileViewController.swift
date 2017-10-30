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
    @IBOutlet weak var logoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //print(PaddlerUser.current!.firstName!)
        let currentUser = PaddlerUser.current!
        
        let fullName = currentUser.fullName!
        let winCount = currentUser.winCount!
        let lossCount = currentUser.lossCount!
        
        if let url = currentUser.profileURL {
            profileImageView.setImageWith(url)
        } else {
            profileImageView.image = UIImage(named: Constants.placeholderImageString)
        }
        
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
        profileImageView.clipsToBounds = true
        profileImageView.layer.borderWidth = 5
        profileImageView.layer.borderColor = UIColor.white.cgColor
        
        playerNameLabel.text = fullName
        playerWinsLabel.text = "\(winCount)"
        playerLossesLabel.text = "\(lossCount)"
        
        logoutButton.layer.cornerRadius = Constants.buttonCornerRadius
        logoutButton.layer.borderWidth = 1
        logoutButton.layer.borderColor = UIColor(red:1.00, green:0.80, blue:0.50, alpha:1.0).cgColor
        
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logOut(_ sender: UIButton) {
        GIDSignIn.sharedInstance().signOut()
        PaddlerUser.current = nil
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = storyboard.instantiateInitialViewController()
        UIApplication.shared.keyWindow?.rootViewController = loginVC
    }

}
