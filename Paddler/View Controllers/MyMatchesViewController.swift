//
//  MyMatchesViewController.swift
//  Paddler
//
//  Created by YingYing Zhang on 10/10/17.
//  Copyright © 2017 Paddler. All rights reserved.
//

import UIKit
import UserNotifications

class MyMatchesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UNUserNotificationCenterDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var requestGameButton: UIButton!
    
    var matches: [Match]!
    var openRequest: Request!
    var currentRequestStatus: Int!
    
    enum RequestState: Int {
        case NO_REQUEST = 0, HAS_OPEN_REQUEST, REQUEST_ACCEPTED
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerForNotifs()
        
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
        
        //print("My full name is " + PaddlerUser.current!.fullname!)

        /*
        let profileNavVC = tabBarController?.viewControllers![3] as! UINavigationController
        let profileVC = profileNavVC.viewControllers[0] as! ProfileViewController
        profileVC.broadcastRequest = Request.createBroadcast()
        */
        
        // if there's an open broadcast or direct request - set button to be Accept Match
        PaddlerUser.current!.hasOpenRequest { (request) in
            if let request = request {
                print("user has open request with: \(request.requestorID!)")
                
                self.requestGameButton.tag = RequestState.HAS_OPEN_REQUEST.rawValue
                self.requestGameButton.setTitle("Accept Match from \((request.requestor?.fullname)!)", for: .normal)
                
                self.openRequest = request
               
                print("open direct request in MyMatchesVC - request id: \(self.openRequest.id!)")
                print("open direct request in MyMatchesVC - requestor name: \(self.openRequest.requestor?.fullname)")
                
                print("open direct request in MyMatchesVC - requestee name: \(self.openRequest.requestee?.fullname)")
                
            }
        }
        
        // refresh control
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

        let requestor = match.requestor!
        let requestee = match.requestee!
        
        if match.requestor?.profileURL != nil {
            let url = match.requestor?.profileURL
            let data = try? Data(contentsOf: url!)
            cell.playerOneImageView.image = UIImage(data: data!)
        } else {
            cell.playerOneImageView.image = UIImage(named:"people-placeholder.png")
        }
        
        if match.requestee?.profileURL != nil {
            let url = match.requestee?.profileURL
            let data = try? Data(contentsOf: url!)
            cell.playerTwoImageView.image = UIImage(data: data!)
        } else {
            cell.playerTwoImageView.image = UIImage(named:"people-placeholder.png")
        }
        
        cell.playerOneNameLabel.text = requestor.fullname
        cell.playerTwoNameLabel.text = requestee.fullname
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
        let navigationController = segue.destination as! UINavigationController
        let liveMatchViewController = navigationController.topViewController as! LiveMatchViewController
            
        if self.requestGameButton.tag == RequestState.NO_REQUEST.rawValue {
            // if current user can request a game, create broadcast, once a requestee accepts game, goes to live game VC
            
            let profileNavVC = tabBarController?.viewControllers![3] as! UINavigationController
            let profileVC = profileNavVC.viewControllers[0] as! ProfileViewController
            profileVC.broadcastRequest = Request.createBroadcast()
            
            print("create broadcast in MyMatchesVC - request id: \(profileVC.broadcastRequest!.id!)")
            print("create broadcast in MyMatchesVC - requestor id: \(profileVC.broadcastRequest!.requestorID!)")
            
            print("create broadcast in MyMatchesVC - requestee id - hard coded: \(profileVC.broadcastRequest!.requesteeID!)")
            //print("hardCodedRequestee: \(hardCodedRequestee)")
            
            //let user = PaddlerUser()
            
            print("create broadcast in MyMatchesVC - requestee - hard coded: \(profileVC.broadcastRequest!.requestee!)")
            print("create broadcast in MyMatchesVC - requestee id: \(profileVC.broadcastRequest!.requesteeID!)")
            print("create broadcast in MyMatchesVC - status: \(profileVC.broadcastRequest!.status!)")
            print("create broadcast in MyMatchesVC - isDirect: \(profileVC.broadcastRequest!.isDirect!)")
            print("create broadcast in MyMatchesVC - createdAt: \(profileVC.broadcastRequest!.createdAt!)")
            
            let match = profileVC.broadcastRequest!.accept()
            
            // figure out a logic to make button in
            print("user has started match: \(match.id!)")
            liveMatchViewController.match = match
            
            
        } else if self.requestGameButton.tag == RequestState.HAS_OPEN_REQUEST.rawValue {
            // if there's a broadcast or a direct request, current user can accept the game as a requestee
            
            print("accept a direct match request")
            
            print("open direct request in MyMatchesVC - request id: \(openRequest.id!)")
            print("open direct request in MyMatchesVC - requestor id: \(openRequest.requestorID!)")
            
            let match = openRequest.accept()
            print("user has accepted match: \(match.id!)")
            liveMatchViewController.match = match

        } //else if self.requestGameButton.tag == RequestState.REQUEST_ACCEPTED { // has made request but waiting for acception
            
            
        //}
    }
    
    func registerForNotifs() {
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
        
        UIApplication.shared.registerForRemoteNotifications()
    }
    
}
