//
//  ContactsViewController.swift
//  Paddler
//
//  Created by YingYing Zhang on 10/10/17.
//  Copyright © 2017 Paddler. All rights reserved.
//

import UIKit

class ContactsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var contacts: [PaddlerUser] = []
    var filteredData: [PaddlerUser] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self
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
            profileVC.directRequest = Request.createDirect(with: users.first!)
            
            self.contacts = users
            self.filteredData = users
    
            self.tableView.reloadData()
        }
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
        
        cell.playerNameLabel.text = "\(contact.firstName!) \(contact.lastName!) "
        
        /*
        // if user has an open request or initiated an open request, disable button
        PaddlerUser.current!.hasOpenRequest { (request) in
            if let request = request {
                cell.requestMatchButton.setTitle("Request Match", for: .disabled)
            }
        }
 */
        
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
                profileVC.directRequest = Request.createDirect(with: contact)
                
                print("create direct in ContactsVC - request id: \(profileVC.directRequest!.id!)")
                print("create direct in ContactsVC - requestor id: \(String(describing: profileVC.directRequest!.requestorID))")
                
                print("create direct in ContactsVC - requestee id: \(profileVC.directRequest!.requesteeID!)")
                
                print("create direct in ContactsVC - status: \(String(describing: profileVC.directRequest!.status))")
                
                print("create direct in ContactsVC - isDirect: \(String(describing: profileVC.directRequest!.isDirect))")
                print("create direct in ContactsVC - createdAt: \(String(describing: profileVC.directRequest!.createdAt))")
                
                let match = profileVC.directRequest!.accept()
                print("user has started match: \(match.id!)")
                
                liveMatchViewController.match = match
                
            } else if requestMatchButton.titleLabel?.text == "Game in Progress" {
                // if there's a game in progress, current user is requestee and can't do anything
                // do nothing
            }
        }
    }
    
    //search bar functionality related
    // This method updates filteredData based on the text in the Search Box
    // When there is no text, filteredData is the same as the original data
    // When user has entered text into the search box
    // Use the filter method to iterate over all items in the data array
    // For each item, return true if the item should be included and false if the
    // item should NOT be included
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("searchText: \(searchText)")
        if !searchText.isEmpty {
            print(self.contacts.count)
            filteredData = self.contacts.filter { (user: PaddlerUser) -> Bool in
                // If dataItem matches the searchText, return true to include it
                let fullName = user.fullname
                print("first match: \(fullName!.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil))")
                return fullName!.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
            }
        } else {
            filteredData = self.contacts
        }
//        filteredData = searchText.isEmpty ? self.contacts : self.contacts.filter { (user: PaddlerUser) -> Bool in
//            // If dataItem matches the searchText, return true to include it
//            let firstName = user.firstName
//            print("first match: \(firstName!.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil))")
//            return firstName!.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
//        }
        
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

}
