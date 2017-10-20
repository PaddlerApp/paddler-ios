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
    var openRequest: Request!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 162

        PaddlerUser.current!.getMatches { (matches) in
            for match in matches {
                print("print in MyMatchesVC - match.createdAt: \(match.createdAt!)")
            }
            
            self.matches = matches
            self.tableView.reloadData()
        }
        
        print("My full name is " + PaddlerUser.current!.fullname!)

        /*
        let profileNavVC = tabBarController?.viewControllers![3] as! UINavigationController
        let profileVC = profileNavVC.viewControllers[0] as! ProfileViewController
        profileVC.broadcastRequest = Request.createBroadcast()
        */
        
        // if there's an open broadcast or direct request - set button to be Accept Match
        PaddlerUser.current!.hasOpenRequest { (request) in
            if let request = request {
                print("user has open request with: \(request.requestorID!)")
                
                self.requestGameButton.setTitle("Accept Match", for: .normal)
                //self.requestGameButton.setTitle("Accept Match from \(request.requestor?.fullname))", for: .normal)
                
                self.openRequest = request
                
               
                print("open direct request in MyMatchesVC - request id: \(self.openRequest.id!)")
                 /*
                print("open direct request in MyMatchesVC - requestor id: \(self.openRequest.requestorID!)")
                
                print("open direct request in MyMatchesVC - requestee id - hard coded: \(self.openRequest.requesteeID!)")
                //print("hardCodedRequestee: \(hardCodedRequestee)")
                print("open direct request in MyMatchesVC - requestee - hard coded: \(self.openRequest.requestee!)")
                print("open direct request in MyMatchesVC - requestee id: \(self.openRequest.requesteeID!)")
                print("open direct request in MyMatchesVC - status: \(self.openRequest.status!)")
                print("open direct request in MyMatchesVC - isDirect: \(self.openRequest.isDirect!)")
                print("open direct request in MyMatchesVC - createdAt: \(self.openRequest.createdAt!)")
                */
            }
        }
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
       let liveMatchViewController = segue.destination as! LiveMatchViewController
            
        if requestGameButton.titleLabel?.text == "Request Match" {
            // if current user can request a game, create broadcast, once a requestee accepts game, goes to live game VC
            //let liveMatchViewController = segue.destination as! LiveMatchViewController
            
            let profileNavVC = tabBarController?.viewControllers![3] as! UINavigationController
            let profileVC = profileNavVC.viewControllers[0] as! ProfileViewController
            profileVC.broadcastRequest = Request.createBroadcast()
            
            print("create broadcast in MyMatchesVC - request id: \(profileVC.broadcastRequest!.id!)")
            print("create broadcast in MyMatchesVC - requestor id: \(profileVC.broadcastRequest!.requestorID!)")
            profileVC.broadcastRequest!.requesteeID = "2zb6QkGXIcTDfZMSxleO8IZ9DTj2"
            print("create broadcast in MyMatchesVC - requestee id - hard coded: \(profileVC.broadcastRequest!.requesteeID!)")
            //print("hardCodedRequestee: \(hardCodedRequestee)")
            
            //let user = PaddlerUser()
            
            print("create broadcast in MyMatchesVC - requestee - hard coded: \(profileVC.broadcastRequest!.requestee!)")
            print("create broadcast in MyMatchesVC - requestee id: \(profileVC.broadcastRequest!.requesteeID!)")
            print("create broadcast in MyMatchesVC - status: \(profileVC.broadcastRequest!.status!)")
            print("create broadcast in MyMatchesVC - isDirect: \(profileVC.broadcastRequest!.isDirect!)")
            print("create broadcast in MyMatchesVC - createdAt: \(profileVC.broadcastRequest!.createdAt!)")
            
            let match = profileVC.broadcastRequest!.accept()
            print("user has started match: \(match.id!)")
            
            liveMatchViewController.match = match
            
        } else if requestGameButton.titleLabel?.text == "Accept Match" {
            // if there's a broadcast or a direct request, current user can accept the game as a requestee
            
            print("accept a direct match request")
            
            print("open direct request in MyMatchesVC - request id: \(openRequest.id!)")
            print("open direct request in MyMatchesVC - requestor id: \(openRequest.requestorID!)")
            
            print("open direct request in MyMatchesVC - requestee id - hard coded: \(openRequest.requesteeID!)")
            //print("hardCodedRequestee: \(hardCodedRequestee)")
            print("open direct request in MyMatchesVC - requestee - hard coded: \(openRequest.requestee!)")
            print("open direct request in MyMatchesVC - requestee id: \(openRequest.requesteeID!)")
            print("open direct request in MyMatchesVC - status: \(openRequest.status!)")
            print("open direct request in MyMatchesVC - isDirect: \(openRequest.isDirect!)")
            print("open direct request in MyMatchesVC - createdAt: \(openRequest.createdAt!)")
            
            let match = openRequest.accept()
            print("user has accepted match: \(match.id!)")
            liveMatchViewController.match = match

        }
    }
    
    
}
