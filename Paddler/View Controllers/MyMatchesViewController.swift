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
    
    @IBOutlet weak var requestButtonWidth: NSLayoutConstraint!
    
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
        
        requestGameButton.layer.cornerRadius = Constants.buttonCornerRadius
        
        user.getMatches { (matches) in
            self.matches = matches
            self.tableView.reloadData()
            MBProgressHUD.hide(for: self.view, animated: true)
        }
        
        // if there's an open broadcast or direct request - set button to be Accept Match
        user.listenForOpenRequest { (request) in
            if let request = request {
                self.setToAcceptButton(request)
            }
        }
        
        user.listenForActiveMatch { (match) in
            if let match = match {
                self.acceptedMatch = match
                self.performSegue(withIdentifier: Constants.matchToLive, sender: self)
                self.setToRequestButton()
            }
        }
        
        // refresh control
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matches.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.matchCellIdentifier, for: indexPath) as! MyMatchCell
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
            setToPendingButton()
        } else if self.requestGameButton.tag == RequestState.HAS_OPEN_REQUEST.rawValue {
            acceptedMatch = openRequest.accept()
            performSegue(withIdentifier: Constants.matchToLive, sender: self)
            setToRequestButton()
        } else if self.requestGameButton.tag == RequestState.REQUEST_PENDING.rawValue {
            print("Does nothing; request is pending")
        }
    }
    
    func setToAcceptButton(_ request: Request) {
        self.openRequest = request
        self.requestGameButton.tag = RequestState.HAS_OPEN_REQUEST.rawValue
        requestGameButton.layer.cornerRadius = Constants.buttonCornerRadius
        UIView.animate(withDuration: Constants.buttonAnimationDuration) {
            self.requestButtonWidth.constant = self.view.frame.width * 0.8
            self.requestGameButton.backgroundColor = Constants.buttonGreenBackground
            self.requestGameButton.setTitle("Accept Match from \(request.requestor!.firstName!)", for: .normal)
            self.requestGameButton.tintColor = UIColor.white
            self.requestGameButton.layer.borderWidth = 0
            self.view.layoutIfNeeded()
        }
    }
    
    func setToRequestButton() {
        requestGameButton.tag = RequestState.NO_REQUEST.rawValue
        requestGameButton.layer.cornerRadius = Constants.buttonCornerRadius
        openRequest = nil
        requestGameButton.isEnabled = true
        UIView.animate(withDuration: Constants.buttonAnimationDuration) {
            self.requestButtonWidth.constant = 130
            self.requestGameButton.backgroundColor = Constants.buttonGreenBackground
            self.requestGameButton.tintColor = UIColor.white
            self.requestGameButton.setTitle(Constants.requestMatchString, for: .normal)
            self.requestGameButton.layer.borderWidth = 0
            self.view.layoutIfNeeded()
        }
    }
    
    func setToPendingButton() {
        requestGameButton.tag = RequestState.REQUEST_PENDING.rawValue
        requestGameButton.layer.cornerRadius = Constants.buttonCornerRadius
        initiatedRequest = Request.createBroadcast()
        requestGameButton.isEnabled = false
        UIView.animate(withDuration: Constants.buttonAnimationDuration) {
            self.requestButtonWidth.constant = 130
            self.requestGameButton.backgroundColor = Constants.buttonOrangeBackground
            self.requestGameButton.tintColor = Constants.buttonOrangeTint
            self.requestGameButton.setTitle(Constants.pendingMatchString, for: .disabled)
            self.requestGameButton.layer.borderWidth = 1
            self.requestGameButton.layer.borderColor = Constants.buttonOrangeBorder.cgColor
            self.view.layoutIfNeeded()
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
