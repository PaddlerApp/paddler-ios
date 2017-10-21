//
//  LiveMatchViewController.swift
//  Paddler
//
//  Created by YingYing Zhang on 10/10/17.
//  Copyright © 2017 Paddler. All rights reserved.
//

import UIKit

class LiveMatchViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var playerOneImageView: UIImageView!
    @IBOutlet weak var playerTwoImageView: UIImageView!
    @IBOutlet weak var playerOneNameLabel: UILabel!
    @IBOutlet weak var playerTwoNameLabel: UILabel!
    @IBOutlet weak var playerOneScoreTextField: UITextField!
    @IBOutlet weak var playerTwoScoreTextField: UITextField!
    
    var match: Match!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("live match id: \(match.id)")
        print("live match created at: \(match.createdAt)")
        print("live match finished at: \(match.finishedAt)")
        print("live match requestor id: \(match.requestorID)")
        print("live match requestee id: \(match.requesteeID)")
        print("live match requestor score: \(match.requestorScore)")
        print("live match requestee score: \(match.requesteeScore)")
        print("live match winner id: \(match.winnerID)")
        print("live match loser id: \(match.loserID)")
        
        let requestor = match.requestor!
        let requestee = match.requestee!
        
        if requestor.profileURL != nil {
            let url = requestor.profileURL
            let data = try? Data(contentsOf: url!)
            playerOneImageView.image = UIImage(data: data!)
            //.setImageWith(currentUser.imageURL!)
        } else {
            playerOneImageView.image = UIImage(named:"people-placeholder.png")
        }
        
        if requestee.profileURL != nil {
            let url = requestee.profileURL
            let data = try? Data(contentsOf: url!)
            playerTwoImageView.image = UIImage(data: data!)
            //.setImageWith(currentUser.imageURL!)
        } else {
            playerTwoImageView.image = UIImage(named:"people-placeholder.png")
        }
        
        playerOneImageView.layer.cornerRadius = playerOneImageView.frame.size.width / 2
        playerOneImageView.clipsToBounds = true
        
        playerTwoImageView.layer.cornerRadius = playerTwoImageView.frame.size.width / 2
        playerTwoImageView.clipsToBounds = true
        
        playerOneNameLabel.text = requestor.fullname
        playerTwoNameLabel.text = requestee.fullname
        
        playerOneScoreTextField.delegate = self
        playerTwoScoreTextField.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveGameButton(_ sender: Any) {
        match.requestorScore = Int(playerOneScoreTextField.text!)
        match.requesteeScore = Int(playerTwoScoreTextField.text!)
        
        match.finish(myScore: match.requestorScore!, andOtherScore: match.requesteeScore!)
        
        print("------------ finished a game ------------")
        print("live match id: \(match.id)")
        print("live match created at: \(match.createdAt)")
        print("live match finished at: \(match.finishedAt)")
        print("live match requestor id: \(match.requestorID)")
        print("live match requestee id: \(match.requesteeID)")
        print("live match requestor score: \(match.requestorScore)")
        print("live match requestee score: \(match.requesteeScore)")
        print("live match winner id: \(match.winnerID)")
        print("live match loser id: \(match.loserID)")
    }
}
