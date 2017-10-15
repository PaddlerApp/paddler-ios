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
    var contacts: [PaddlerUser]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
        if contacts != nil {
            return contacts!.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath) as! ContactCell
        
        let contact = contacts[indexPath.row]
        
        cell.playerNameLabel.text = "\(contact.firstName!) \(contact.lastName!) "
        //cell.requestGameButton. = "Request Game"
        
        cell.selectionStyle = .none // get rid of gray selection
        
        return cell
    }

}
