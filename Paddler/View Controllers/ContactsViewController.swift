//
//  ContactsViewController.swift
//  Paddler
//
//  Created by YingYing Zhang on 10/10/17.
//  Copyright © 2017 Paddler. All rights reserved.
//

import UIKit
import MBProgressHUD

class ContactsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, LiveMatchViewControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var contacts: [PaddlerUser] = []
    var filteredData: [PaddlerUser] = []
    
    var shouldDisableButton: Bool = false

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
        cell.requestMatchButton.isEnabled = !shouldDisableButton
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
            let requestMatchButton = sender as! UIButton
            if requestMatchButton.tag == RequestState.NO_REQUEST.rawValue {
                // if current user can request a game, create broadcast, once a requestee accepts game, goes to live game VC
                let navigationController = segue.destination as! UINavigationController
                let liveMatchViewController = navigationController.topViewController as! LiveMatchViewController
                requestMatchButton.tag = RequestState.REQUEST_PENDING.rawValue
                self.shouldDisableButton = true
                self.tableView.reloadData()
                liveMatchViewController.delegate = self
            } else if requestMatchButton.tag == RequestState.REQUEST_PENDING.rawValue {
                // Yingying: do we need a pending state? somehow we need to be able to show on button title that "Your request is waiting for response"
                // Disable all buttons on Contacts page
            }
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
        //searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
        tableView.reloadData()
    }
    //search bar functionality related - end
    
    func didSaveMatch() {
        // a func to go back to My Matches View Controller
        tabBarController?.selectedIndex = 0
    }
    
    @IBAction func onTapView(_ sender: Any) {
        view.endEditing(true)
        searchBar.showsCancelButton = false
    }

}
