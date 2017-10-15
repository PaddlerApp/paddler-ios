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
    
    var rank: Int = 1
    
    var users: [PaddlerUser]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 60
        
        // Do any additional setup after loading the view.
        PaddlerUser.leaderboard { (users) in
            for user in users {
                print(user.winCount!)
            }
            
            self.users = users
            
            self.tableView.reloadData()
        }
        
        PaddlerUser.current!.hasInitiatedRequest { (request) in
            if let request = request {
                print("user has initiatied request: \(request.id!)")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if users != nil {
            return users!.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "rankCell", for: indexPath) as! RankCell
        
        let user = users[indexPath.row]
        
        cell.rankLabel.text = "\(rank)"
        rank = rank + 1
        
        cell.playerFirstNameLabel.text = user.firstName
        cell.playerLastNameLabel.text = user.lastName
        cell.playerWinsLabel.text = "\(user.winCount ?? 0)"
        cell.playerLossesLabel.text = "\(user.lossCount ?? 0)"
        
        cell.selectionStyle = .none
        
        return cell
    }

}
