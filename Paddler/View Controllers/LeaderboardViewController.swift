//
//  LeaderboardViewController.swift
//  Paddler
//
//  Created by YingYing Zhang on 10/10/17.
//  Copyright © 2017 Paddler. All rights reserved.
//

import UIKit

class LeaderboardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var users: [PaddlerUser] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 60
        
        PaddlerUser.leaderboard { (users) in
            self.users = users
            self.tableView.reloadData()
        }
        
        PaddlerUser.current!.hasInitiatedRequest { (request) in
            if let request = request {
                print("user has an initiated request: \(request.id!)")
            }
        }
        
        // refresh control
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "rankCell", for: indexPath) as! RankCell
        
        let user = users[indexPath.row]
        
        cell.rankLabel.text = "\(indexPath.row+1)"
        
        if user.profileURL != nil {
            let url = user.profileURL
            let data = try? Data(contentsOf: url!)
            cell.profileImageView.image = UIImage(data: data!)
        } else {
            cell.profileImageView.image = UIImage(named:"people-placeholder.png")
        }
        
        cell.playerFirstNameLabel.text = user.firstName
        cell.playerLastNameLabel.text = user.lastName
        cell.playerWinsLabel.text = "\(user.winCount ?? 0)"
        cell.playerLossesLabel.text = "\(user.lossCount ?? 0)"
        
        cell.selectionStyle = .none
        
        return cell
    }

    @objc func refreshControlAction(_ refreshControl: UIRefreshControl) {
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 162
        
        PaddlerUser.leaderboard { (users) in
            self.users = users
            self.tableView.reloadData()
            refreshControl.endRefreshing()
        }
    }
}
