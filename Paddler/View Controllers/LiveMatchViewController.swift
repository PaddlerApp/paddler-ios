//
//  LiveMatchViewController.swift
//  Paddler
//
//  Created by YingYing Zhang on 10/10/17.
//  Copyright © 2017 Paddler. All rights reserved.
//

import UIKit

protocol LiveMatchViewControllerDelegate : class {
    func didSaveMatch()
}

class LiveMatchViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var playerOneImageView: UIImageView!
    @IBOutlet weak var playerTwoImageView: UIImageView!
    @IBOutlet weak var playerOneNameLabel: UILabel!
    @IBOutlet weak var playerTwoNameLabel: UILabel!
    @IBOutlet weak var playerOneScoreTextField: UITextField!
    @IBOutlet weak var playerTwoScoreTextField: UITextField!
    
    weak var delegate : LiveMatchViewControllerDelegate!
    
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
        
        match.listenForFinish {
            self.dismiss(animated: true, completion: nil)
        }
        
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
        
        playerOneScoreTextField.becomeFirstResponder()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCancelButton(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveGameButton(_ sender: Any) {
        match.requestorScore = Int(playerOneScoreTextField.text!)
        match.requesteeScore = Int(playerTwoScoreTextField.text!)
        
        match.finish(requestorScore: match.requestorScore!, andRequesteeScore: match.requesteeScore!)
        
        self.delegate?.didSaveMatch()
        
        print("------------ finished a game ------------")
        print("finish game - live match id: \(match.id)")
        print("finish game - live match created at: \(match.createdAt)")
        print("finish game - live match finished at: \(match.finishedAt)")
        print("finish game - live match requestor id: \(match.requestorID)")
        print("finish game - live match requestee id: \(match.requesteeID)")
        print("finish game - live match requestor score: \(match.requestorScore)")
        print("finish game - live match requestee score: \(match.requesteeScore)")
        print("finish game - live match winner id: \(match.winnerID)")
        print("finish game - live match loser id: \(match.loserID)")
        
        dismiss(animated: true, completion: nil)
        
    }
}
