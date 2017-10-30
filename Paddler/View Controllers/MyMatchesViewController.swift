//
//  MyMatchesViewController.swift
//  Paddler
//
//  Created by YingYing Zhang on 10/10/17.
//  Copyright © 2017 Paddler. All rights reserved.
//

import UIKit
import UserNotifications
import MBProgressHUD

protocol MyMatchesViewControllerDelegate: class {
    func changeMyMatchesVCButtonState(_ color: UIColor?)
}

class MyMatchesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, LiveMatchViewControllerDelegate, UNUserNotificationCenterDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var requestGameButton: UIButton!
    weak var delegate: MyMatchesViewControllerDelegate?
    
    var matches: [Match] = []
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
        
        requestGameButton.layer.cornerRadius = 5
        requestGameButton.layer.shadowColor = UIColor(red:0.18, green:0.49, blue:0.20, alpha:1.0).cgColor
        requestGameButton.layer.shadowOffset = CGSize(width: 1, height: 1)
        requestGameButton.layer.shadowRadius = 1
        requestGameButton.layer.shadowOpacity = 0.5
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 162
        
        // Display HUD right before the request is made
        MBProgressHUD.showAdded(to: self.view, animated: true)

        let user = PaddlerUser.current!
        
        user.getMatches { (matches) in
            self.matches = matches
            self.tableView.reloadData()
            MBProgressHUD.hide(for: self.view, animated: true)
        }
        
        // default value
        requestGameButton.tag = RequestState.NO_REQUEST.rawValue
        
        // if there's an open broadcast or direct request - set button to be Accept Match
        user.hasOpenRequest { (request) in
            if let request = request {
                self.openRequest = request
                self.requestGameButton.tag = RequestState.HAS_OPEN_REQUEST.rawValue
                self.requestGameButton.setTitle("Accept Match from \(request.requestor!.fullName!)", for: .normal)
            }
        }
        
        user.listenForActiveMatch { (match) in
            if let match = match {
                self.acceptedMatch = match
                self.performSegue(withIdentifier: "myMatchesToLiveMatchSegue", sender: self)
                self.requestGameButton.tag = RequestState.NO_REQUEST.rawValue
                self.requestGameButton.isEnabled = true
                self.requestGameButton.setTitle("Request Match", for: .normal)
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
        return matches.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "matchCell", for: indexPath) as! MyMatchCell
        cell.match = matches[indexPath.row]
        return cell
    }

    @objc func refreshControlAction(_ refreshControl: UIRefreshControl) {
        PaddlerUser.current!.getMatches { (matches) in
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
            
        } else if self.requestGameButton.tag == RequestState.HAS_OPEN_REQUEST.rawValue {
            
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
