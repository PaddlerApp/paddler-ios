//
//  MyMatchCell.swift
//  Paddler
//
//  Created by YingYing Zhang on 10/14/17.
//  Copyright © 2017 Paddler. All rights reserved.
//

import UIKit
import AFNetworking

class MyMatchCell: UITableViewCell {

    @IBOutlet weak var matchTimestampLabel: UILabel!
    @IBOutlet weak var playerOneImageView: UIImageView!
    @IBOutlet weak var playerTwoImageView: UIImageView!
    @IBOutlet weak var playerOneNameLabel: UILabel!
    @IBOutlet weak var playerTwoNameLabel: UILabel!
    @IBOutlet weak var playerOneScoreLabel: UILabel!
    @IBOutlet weak var playerTwoScoreLabel: UILabel!
    
    var match: Match! {
        didSet {
            updateViews()
        }
    }
    
    // playerOne is always the requestor
    // playerTwo is always the requestee
    
    func updateViews() {
        self.matchTimestampLabel.text = String(describing: match.createdAt!)
        
        let requestor = match.requestor!
        let requestee = match.requestee!
        
        playerOneImageView.layer.borderWidth = 3
        playerOneImageView.layer.borderColor = UIColor.white.cgColor
        
        playerTwoImageView.layer.borderWidth = 3
        playerTwoImageView.layer.borderColor = UIColor.white.cgColor
        
        if let url = match.requestor?.profileURL {
            self.playerOneImageView.setImageWith(url)
        } else {
            self.playerOneImageView.image = UIImage(named:"people-placeholder.png")
        }
        
        if let url = match.requestee?.profileURL {
            self.playerTwoImageView.setImageWith(url)
        } else {
            self.playerTwoImageView.image = UIImage(named:"people-placeholder.png")
        }
        
        self.playerOneNameLabel.text = requestor.firstName!
        self.playerTwoNameLabel.text = requestee.firstName!
        self.playerOneScoreLabel.text = String(describing: match.requestorScore!)
        self.playerTwoScoreLabel.text = String(describing: match.requesteeScore!)
        
        self.selectionStyle = .none // get rid of gray selection
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        playerOneImageView.layer.cornerRadius = playerOneImageView.frame.size.width / 2
        playerOneImageView.clipsToBounds = true
        playerTwoImageView.layer.cornerRadius = playerTwoImageView.frame.size.width / 2
        playerTwoImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
