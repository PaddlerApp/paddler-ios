//
//  MyMatchesViewController.swift
//  Paddler
//
//  Created by YingYing Zhang on 10/10/17.
//  Copyright © 2017 Paddler. All rights reserved.
//

import UIKit
import UserNotifications

protocol MyMatchesViewControllerDelegate: class {
    func changeMyMatchesVCButtonState(_ color: UIColor?)
}

class MyMatchesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, LiveMatchViewControllerDelegate, UNUserNotificationCenterDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var requestGameButton: UIButton!
    weak var delegate: MyMatchesViewControllerDelegate?
    
    var matches: [Match]!
    var openRequest: Request!
    var initiatedRequest: Request!
    var currentRequestStatus: Int!
    var acceptedMatch: Match!
    
    enum RequestState: Int {
        case NO_REQUEST = 0, HAS_OPEN_REQUEST, REQUEST_PENDING, REQUEST_ACCEPTED
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        refreshMatches()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerForNotifs()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 162

        PaddlerUser.current!.getMatches { (matches) in
            self.matches = matches
            self.tableView.reloadData()
        }
        
        // default value
        requestGameButton.tag = RequestState.NO_REQUEST.rawValue
        
        // if there's an open broadcast or direct request - set button to be Accept Match
        PaddlerUser.current!.hasOpenRequest { (request) in
            if let request = request {
                self.openRequest = request
                self.requestGameButton.tag = RequestState.HAS_OPEN_REQUEST.rawValue
                self.requestGameButton.setTitle("Accept Match from \(request.requestor!.fullname!)", for: .normal)
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
        
        if self.requestGameButton.tag == RequestState.NO_REQUEST.rawValue {
            // if current user can request a game, create broadcast, once a requestee accepts game, goes to live game VC
            
            initiatedRequest = Request.createBroadcast()
            requestGameButton.isEnabled = false
            requestGameButton.setTitle("Request Pending", for: .disabled)
            requestGameButton.tag = RequestState.REQUEST_PENDING.rawValue
//            print("create broadcast in MyMatchesVC - request id: \(profileVC.broadcastRequest!.id!)")
//            print("create broadcast in MyMatchesVC - requestor id: \(profileVC.broadcastRequest!.requestorID!)")
//            print("create broadcast in MyMatchesVC - requestee id - hard coded: \(profileVC.broadcastRequest!.requesteeID!)")
            
        } else if self.requestGameButton.tag == RequestState.HAS_OPEN_REQUEST.rawValue {
            // if there's a broadcast or a direct request, current user can accept the game as a requestee
            
            //            print("accept a direct match request")
            //            print("open direct request in MyMatchesVC - request id: \(openRequest.id!)")
            //            print("open direct request in MyMatchesVC - requestor id: \(openRequest.requestorID!)")
            
            acceptedMatch = openRequest.accept()
            performSegue(withIdentifier: "myMatchesToLiveMatchSegue", sender: self)
            openRequest = nil
            requestGameButton.tag = RequestState.NO_REQUEST.rawValue
            requestGameButton.isEnabled = true
            self.requestGameButton.setTitle("Request Match", for: .normal)
        } else if self.requestGameButton.tag == RequestState.REQUEST_PENDING.rawValue { // current user has made request but waiting for acception
            
            print("Does nothing; request is pending")
            
        } else if self.requestGameButton.tag == RequestState.REQUEST_ACCEPTED.rawValue { // current user made request and got accepted
            
            // Yingying: We have two ways to do this:
            // 1. as soon as the match is accepted, goes to the live match screen (simplest)
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigationController = segue.destination as! UINavigationController
        let liveMatchViewController = navigationController.topViewController as! LiveMatchViewController
        
        liveMatchViewController.match = acceptedMatch
        
        liveMatchViewController.delegate = self
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
    
    func didSaveMatch() {
        refreshMatches()
    }
    
    private func refreshMatches() {
        PaddlerUser.current!.getMatches { (matches) in
            self.matches = matches
            self.tableView.reloadData()
        }
    }
}
