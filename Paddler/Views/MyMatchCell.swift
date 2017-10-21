//
//  MyMatchCell.swift
//  Paddler
//
//  Created by YingYing Zhang on 10/14/17.
//  Copyright © 2017 Paddler. All rights reserved.
//

import UIKit

class MyMatchCell: UITableViewCell {

    @IBOutlet weak var matchTimestampLabel: UILabel!
    @IBOutlet weak var playerOneImageView: UIImageView!
    @IBOutlet weak var playerTwoImageView: UIImageView!
    @IBOutlet weak var playerOneNameLabel: UILabel!
    @IBOutlet weak var playerTwoNameLabel: UILabel!
    @IBOutlet weak var playerOneScoreLabel: UILabel!
    @IBOutlet weak var playerTwoScoreLabel: UILabel!
    
    // playerOne is always the requestor
    // playerTwo is always the requestee
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        playerOneImageView.layer.cornerRadius = 20
        playerOneImageView.clipsToBounds = true
        playerTwoImageView.layer.cornerRadius = 20
        playerTwoImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
