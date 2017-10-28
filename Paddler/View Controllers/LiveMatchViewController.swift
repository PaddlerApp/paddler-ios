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
        
        let requestor = match.requestor!
        let requestee = match.requestee!
        
        match.onComplete {
            self.dismiss(animated: true, completion: nil)
        }
        
        if let url = requestor.profileURL {
            playerOneImageView.setImageWith(url)
        } else {
            playerOneImageView.image = UIImage(named:"people-placeholder.png")
        }
        
        if let url = requestee.profileURL {
            playerTwoImageView.setImageWith(url)
        } else {
            playerTwoImageView.image = UIImage(named:"people-placeholder.png")
        }
        
        playerOneImageView.layer.cornerRadius = playerOneImageView.frame.size.width / 2
        playerOneImageView.clipsToBounds = true
        
        playerTwoImageView.layer.cornerRadius = playerTwoImageView.frame.size.width / 2
        playerTwoImageView.clipsToBounds = true
        
        playerOneNameLabel.text = requestor.fullName
        playerTwoNameLabel.text = requestee.fullName
        
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
        match.cancel()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveGameButton(_ sender: Any) {
        match.requestorScore = Int(playerOneScoreTextField.text!)
        match.requesteeScore = Int(playerTwoScoreTextField.text!)
        
        match.finish(requestorScore: match.requestorScore!, andRequesteeScore: match.requesteeScore!)
        
        self.delegate?.didSaveMatch()
        
        dismiss(animated: true, completion: nil)
    }
}
