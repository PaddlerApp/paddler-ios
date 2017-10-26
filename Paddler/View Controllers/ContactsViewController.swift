//
//  ContactsViewController.swift
//  Paddler
//
//  Created by YingYing Zhang on 10/10/17.
//  Copyright © 2017 Paddler. All rights reserved.
//

import UIKit

class ContactsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, LiveMatchViewControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var contacts: [PaddlerUser] = []
    var filteredData: [PaddlerUser] = []
    
    var users: [PaddlerUser]! // used to test request match actions
    
    enum RequestState: Int {
        case NO_REQUEST = 0, HAS_OPEN_REQUEST, REQUEST_PENDING, REQUEST_ACCEPTED
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 60
        
        PaddlerUser.leaderboard { (users) in
            self.users = users
            print("user from leaderboard: \(self.users)")
        }
        
        PaddlerUser.contacts { (users) in
            for user in users {
                print(user.lastName!)
            }
            
            let profileNavVC = self.tabBarController?.viewControllers![3] as! UINavigationController
            let profileVC = profileNavVC.viewControllers[0] as! ProfileViewController
            profileVC.directRequest = Request.createDirect(with: users.first!)
            
            self.contacts = users
            self.filteredData = users
    
            self.tableView.reloadData()
        }
        
        // refresh control
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if contacts != nil {
            return filteredData.count //return filteredData!.count
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath) as! ContactCell
        
        let contact = filteredData[indexPath.row]
        cell.requestMatchButton.tag = indexPath.row
        
        if contact.profileURL != nil {
            let url = contact.profileURL
            let data = try? Data(contentsOf: url!)
            cell.profileImageView.image = UIImage(data: data!)
        } else {
            cell.profileImageView.image = UIImage(named:"people-placeholder.png")
        }
        
        cell.playerNameLabel.text = "\(contact.fullname!) "
        
        // default value
        cell.requestMatchButton.tag = RequestState.NO_REQUEST.rawValue
        
        // if user has an open request or initiated an open request, disable button
        PaddlerUser.current!.hasOpenRequest { (request) in
            if let request = request {
                cell.requestMatchButton.setTitle("Request Match", for: .disabled)
            }
        }
 
        
        cell.selectionStyle = .none // get rid of gray selection
        
        return cell
    }
    
    @objc func refreshControlAction(_ refreshControl: UIRefreshControl) {
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 162
        
        PaddlerUser.contacts { (users) in
            self.contacts = users
            self.filteredData = users
            self.tableView.reloadData()
            refreshControl.endRefreshing()
        }

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "contactsToLiveMatchSegue" {
            
            let requestMatchButton = sender as! UIButton
            let indexPath = requestMatchButton.tag
            let contact = contacts[indexPath]
            
            //print("contact: \(contact.fullname)")
            
            if requestMatchButton.tag == RequestState.NO_REQUEST.rawValue {
                // if current user can request a game, create broadcast, once a requestee accepts game, goes to live game VC
                let navigationController = segue.destination as! UINavigationController
                let liveMatchViewController = navigationController.topViewController as! LiveMatchViewController
            
                let profileNavVC = tabBarController?.viewControllers![3] as! UINavigationController
                let profileVC = profileNavVC.viewControllers[0] as! ProfileViewController
               
                // test data
                let user  = users[6] // get first user from leaderboard
                let contact = user
                print("actual user object: \(contact.fullname)")
                
                profileVC.directRequest = Request.createDirect(with: contact)
                
                requestMatchButton.tag = RequestState.REQUEST_PENDING.rawValue
                
                //self.tableView.reloadData()
                
                // how can I not go to segue
    
                let match = profileVC.directRequest!.accept()
                print("user has started match: \(match.id!)")
                liveMatchViewController.match = match
                liveMatchViewController.delegate = self
                
            } else if requestMatchButton.tag == RequestState.REQUEST_PENDING.rawValue {
                // Yingying: do we need a pending state? somehow we need to be able to show on button title that "Your request is waiting for response"
                
                // Disable all buttons on Contacts page
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("searchText: \(searchText)")
        if !searchText.isEmpty {
            print(self.contacts.count)
            filteredData = self.contacts.filter { (user: PaddlerUser) -> Bool in
                // If dataItem matches the searchText, return true to include it
                let fullName = user.fullname
                return fullName!.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
            }
        } else {
            filteredData = self.contacts
        }
        
        tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    //search bar functionality related - end
    
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
    
    func didSaveMatch() {
        // a func to go back to My Matches View Controller
        tabBarController?.selectedIndex = 0
    }

}
