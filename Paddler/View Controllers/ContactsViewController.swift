//
//  ContactsViewController.swift
//  Paddler
//
//  Created by YingYing Zhang on 10/10/17.
//  Copyright © 2017 Paddler. All rights reserved.
//

import UIKit
import MBProgressHUD

protocol ContactsViewControllerDelegate : class {
    func requestMatchButtonTapped(cell: ContactCell)
}

class ContactsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, LiveMatchViewControllerDelegate, ContactsViewControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var contacts: [PaddlerUser] = []
    var filteredData: [PaddlerUser] = []
    var acceptedMatch: Match!
    var initiatedRequest: Request!
    
    var shouldDisableButton: Bool = false

    var isRequested: Bool = false
    var isRequestedUser: PaddlerUser? = nil
    
    private var isSearching: Bool = false
    
    override func viewDidAppear(_ animated: Bool) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        PaddlerUser.contacts { (users) in
            PaddlerUser.current!.hasInitiatedRequest { (request) in
                if request != nil {
                    self.shouldDisableButton = true
                }
                
                self.contacts = users
                self.filteredData = users
                
                self.tableView.reloadData()
                MBProgressHUD.hide(for: self.view, animated: true)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self
        searchBar.backgroundImage = UIImage(named: Constants.orangeImageString)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 70
        
        let user = PaddlerUser.current!
        
        user.listenForActiveMatch { (match) in
            if let match = match {
                self.acceptedMatch = match
                self.performSegue(withIdentifier: Constants.contactToLive, sender: self)
                self.isRequested = false
                self.isRequestedUser = nil
                self.shouldDisableButton = false
                self.tableView.reloadData()
            }
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
        if isSearching {
            return filteredData.count
        } else {
            return contacts.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.contactCellIdentifier, for: indexPath) as! ContactCell
        let data = isSearching ? filteredData : contacts
        cell.contact = data[indexPath.row]
        cell.delegate = self
        
        if isRequestedUser != nil { // YES! Has direct request
            if isRequestedUser == cell.contact { // current cell is the request user, disable button + change button text
                isRequested = true
                cell.requestMatchButton.tag = RequestState.REQUEST_PENDING.rawValue
                cell.requestMatchButton.setTitle(Constants.pendingMatchString, for: .disabled)
                cell.requestMatchButton.isEnabled = shouldDisableButton
                
            } else { // current cell is NOT the request user, disable button
                cell.requestMatchButton.isEnabled = shouldDisableButton
            }
            
        } else if isRequestedUser == nil{ // NO direct request
            isRequested = false
            shouldDisableButton = false
            cell.requestMatchButton.tag = RequestState.NO_REQUEST.rawValue
            cell.requestMatchButton.isEnabled = !shouldDisableButton
            cell.requestMatchButton.setTitle(Constants.requestMatchString, for: .normal)
        }
        
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
        self.shouldDisableButton = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.contactToLive {
            let navigationController = segue.destination as! UINavigationController
            let liveMatchViewController = navigationController.topViewController as! LiveMatchViewController
            liveMatchViewController.match = acceptedMatch
            liveMatchViewController.delegate = self
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData = searchText.isEmpty ? self.contacts : self.contacts.filter { (user: PaddlerUser) -> Bool in
            let fullName = user.fullName!
            return fullName.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        
        tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isSearching = true
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        isSearching = false
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
        tableView.reloadData()
    }
    //search bar functionality related - end
    
    func didSaveMatch() {
        // a func to go back to My Matches View Controller
        //tabBarController?.selectedIndex = 0
        isRequested = false
        isRequestedUser = nil
        refreshContacts()
        self.tableView.reloadData()
    }
    
    private func refreshContacts() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        PaddlerUser.contacts { (users) in
            PaddlerUser.current!.hasInitiatedRequest { (request) in
                if request != nil {
                    self.shouldDisableButton = true
                }
                
                self.contacts = users
                self.filteredData = users
                
                self.tableView.reloadData()
                MBProgressHUD.hide(for: self.view, animated: true)
            }
        }
    }
    
    @IBAction func onTapView(_ sender: Any) {
        searchBar.showsCancelButton = false
        view.endEditing(true)
    }
    
    // request match button tapped in contact view
    func requestMatchButtonTapped(cell: ContactCell) {
        // define what should happen when this butotn is tapped
        isRequestedUser = cell.contact // pass tapped cell to Contacts VC
        self.tableView.reloadData()
        initiatedRequest = Request.createDirect(with: isRequestedUser!)
        print("initiatedRequest: \(initiatedRequest)")
    }

}
