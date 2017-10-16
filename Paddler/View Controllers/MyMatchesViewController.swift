//
//  MyMatchesViewController.swift
//  Paddler
//
//  Created by YingYing Zhang on 10/10/17.
//  Copyright © 2017 Paddler. All rights reserved.
//

import UIKit

class MyMatchesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var requestGameButton: UIButton!
    
    var matches: [Match]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 162
        // Do any additional setup after loading the view.
        PaddlerUser.current!.getMatches { (matches) in
            for match in matches {
                print("print in MyMatchesVC - match.createdAt: \(match.createdAt!)")
            }
            
            self.matches = matches
            self.tableView.reloadData()
        }
        
        /*
        let profileNavVC = tabBarController?.viewControllers![3] as! UINavigationController
        let profileVC = profileNavVC.viewControllers[0] as! ProfileViewController
        profileVC.broadcastRequest = Request.createBroadcast()
        */
        
        /*
        PaddlerUser.current!.hasOpenRequest { (request) in
            if let request = request {
                print("user has open request with: \(request.requestorID!)")
                let match = request.accept()
                print("user has started match: \(match.id!)")
                match.finish(myScore: 11, andOtherScore: 3)
            }
        }
 */
        
        // refresh control
        let refreshControl = UIRefreshControl()
        
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        
        tableView.insertSubview(refreshControl, at: 0)
        // refresh control - end
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if matches != nil {
            return matches!.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "matchCell", for: indexPath) as! MyMatchCell
        
        let match = matches[indexPath.row]
        
        cell.matchTimestampLabel.text = "\(String(describing: match.createdAt!))"
        
        /* Add profile Image
         //thumbImageView.setImageWith(business.imageURL!)
         if business.imageURL != nil {
         thumbImageView.setImageWith(business.imageURL!)
         } else {
         //thumbImageView.setImageWith(UIImage(named:"bizimage-small.png"))
         thumbImageView.image = UIImage(named:"bizimage-small.png")
         }
         */
        
        let requestor = match.requestor!
        let requestee = match.requestee!
        
        cell.playerOneNameLabel.text = requestor.firstName! + " " + requestor.lastName!
        cell.playerTwoNameLabel.text = requestee.firstName! + " " + requestee.lastName!
        cell.playerOneScoreLabel.text = "\(String(describing: match.requestorScore!))"
        cell.playerTwoScoreLabel.text = "\(String(describing: match.requesteeScore!))"
        
        cell.selectionStyle = .none // get rid of gray selection
        
        return cell
    }

    @objc func refreshControlAction(_ refreshControl: UIRefreshControl) {
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 162
        
        PaddlerUser.current!.getMatches { (matches) in
            for match in matches {
                print("refresh control in MyMatchesVC - match.createdAt: \(match.createdAt!)")
            }
            
            self.matches = matches
            self.tableView.reloadData()
            refreshControl.endRefreshing()
        }
    }
    
    @IBAction func requestGameButtonAction(_ sender: Any) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "myMatchesToLiveMatchSegue" {
            
            if requestGameButton.titleLabel?.text == "Request Match" {
                // if current user can request a game, create broadcast, once a requestee accepts game, goes to live game VC
                let liveMatchViewController = segue.destination as! LiveMatchViewController
                
                let profileNavVC = tabBarController?.viewControllers![3] as! UINavigationController
                let profileVC = profileNavVC.viewControllers[0] as! ProfileViewController
                profileVC.broadcastRequest = Request.createBroadcast()
                
                print("create broadcast in MyMatchesVD - request id: \(profileVC.broadcastRequest!.id!)")
                print("create broadcast in MyMatchesVD - requestor id: \(profileVC.broadcastRequest!.requestorID!)")
                
                print("create broadcast in MyMatchesVD - requestee id: \(profileVC.broadcastRequest!.requesteeID!)")
                
                print("create broadcast in MyMatchesVD - status: \(profileVC.broadcastRequest!.status!)")
                
                print("create broadcast in MyMatchesVD - isDirect: \(profileVC.broadcastRequest!.isDirect!)")
                print("create broadcast in MyMatchesVD - createdAt: \(profileVC.broadcastRequest!.createdAt!)")
                
                profileVC.broadcastRequest!.requesteeID = "2zb6QkGXIcTDfZMSxleO8IZ9DTj2"
                
                let match = profileVC.broadcastRequest!.accept()
                print("user has started match: \(match.id!)")
                
                liveMatchViewController.match = match
                /*
                 PaddlerUser.current!.hasOpenRequest { (request) in
                 if let request = request {
                 print("user has open request with: \(request.requestorID!)")
                 let match = request.accept()
                 print("user has started match: \(match.id!)")
                 self.matchId = match.id!
                 //match.finish(myScore: 11, andOtherScore: 3)
                 }
                 }
                 */
                
            } else if requestGameButton.titleLabel?.text == "Accept Match" {
                // if there's a broadcast or a direct request, current user can accept the game as a requestee
                
            } else if requestGameButton.titleLabel?.text == "Game in Progress" {
                // if there's a game in progress, current user is requestee and can't do anything
                // do nothing
            }
        } 
    }
    
}
