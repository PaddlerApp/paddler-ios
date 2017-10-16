//
//  ContactsViewController.swift
//  Paddler
//
//  Created by YingYing Zhang on 10/10/17.
//  Copyright © 2017 Paddler. All rights reserved.
//

import UIKit

class ContactsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var contacts: [PaddlerUser] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 60
        
        PaddlerUser.contacts { (users) in
            for user in users {
                print(user.lastName!)
            }
            
            let profileNavVC = self.tabBarController?.viewControllers![3] as! UINavigationController
            let profileVC = profileNavVC.viewControllers[0] as! ProfileViewController
            profileVC.directRequest = Request.createDirect(with: users.first!.id!)
            
            self.contacts = users
            //print("contacts in ContactsVC = \(self.contacts)")
            //print("contact count: \(self.contacts!.count)")
            
            self.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath) as! ContactCell
        
        let contact = contacts[indexPath.row]
        cell.requestMatchButton.tag = indexPath.row
        
        cell.playerNameLabel.text = "\(contact.firstName!) \(contact.lastName!) "
        //cell.requestGameButton. = "Request Game"
        
        cell.selectionStyle = .none // get rid of gray selection
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "contactsToLiveMatchSegue" {
            
            let requestMatchButton = sender as! UIButton
            let indexPath = requestMatchButton.tag
            let contact = contacts[indexPath]
            
            
            if requestMatchButton.titleLabel?.text == "Request Match" {
                // if current user can request a game, create broadcast, once a requestee accepts game, goes to live game VC
                let liveMatchViewController = segue.destination as! LiveMatchViewController
            
                let profileNavVC = tabBarController?.viewControllers![3] as! UINavigationController
                let profileVC = profileNavVC.viewControllers[0] as! ProfileViewController
                profileVC.directRequest = Request.createDirect(with: contact.id!)
                
                print("create direct in MyMatchesVD - request id: \(profileVC.directRequest!.id!)")
                print("create direct in MyMatchesVD - requestor id: \(String(describing: profileVC.directRequest!.requestorID))")
                
                print("create direct in MyMatchesVD - requestee id: \(profileVC.directRequest!.requesteeID!)")
                
                print("create direct in MyMatchesVD - status: \(String(describing: profileVC.directRequest!.status))")
                
                print("create direct in MyMatchesVD - isDirect: \(String(describing: profileVC.directRequest!.isDirect))")
                print("create direct in MyMatchesVD - createdAt: \(String(describing: profileVC.directRequest!.createdAt))")
                
                let match = profileVC.directRequest!.accept()
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
                
            } else if requestMatchButton.titleLabel?.text == "Game in Progress" {
                // if there's a game in progress, current user is requestee and can't do anything
                // do nothing
            }
        }
    }
    
    @IBAction func onTapButton(_ sender: UITapGestureRecognizer) {
        var view: UIView!
        var loc: CGPoint!
        
        view = sender.view
        loc = sender.location(in: view)
        
        var indexPath: Int!
        
        indexPath = view.hitTest(loc, with: nil)?.tag
    
        //print("indexPath: \(indexPath)")
        
        self.performSegue(withIdentifier: "homeTimelineToProfileSegue", sender: indexPath)
    }

}
