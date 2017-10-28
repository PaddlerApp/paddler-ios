//
//  RankCell.swift
//  Paddler
//
//  Created by YingYing Zhang on 10/14/17.
//  Copyright © 2017 Paddler. All rights reserved.
//

import UIKit

class RankCell: UITableViewCell {

    @IBOutlet weak var rankLabel: UILabel!
    
    @IBOutlet weak var playerFirstNameLabel: UILabel!
    @IBOutlet weak var playerLastNameLabel: UILabel!
    
    @IBOutlet weak var playerWinsLabel: UILabel!
    @IBOutlet weak var playerLossesLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    var user: PaddlerUser! {
        didSet {
            updateViews()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
        profileImageView.clipsToBounds = true
    }
    
    private func updateViews() {
        self.playerFirstNameLabel.text = user.firstName
        self.playerLastNameLabel.text = user.lastName
        self.playerWinsLabel.text = "\(user.winCount ?? 0)"
        self.playerLossesLabel.text = "\(user.lossCount ?? 0)"
        self.selectionStyle = .none
        
        if let url = user.profileURL {
            self.profileImageView.setImageWith(url)
        } else {
            self.profileImageView.image = UIImage(named:"people-placeholder.png")
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
