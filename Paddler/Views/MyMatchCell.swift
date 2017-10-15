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
    //@IBOutlet weak var playerOneWinnerImageView: UIImageView!
    //@IBOutlet weak var playerTwoWinnerImageView: UIImageView!
    @IBOutlet weak var playerOneNameLabel: UILabel!
    @IBOutlet weak var playerTwoNameLabel: UILabel!
    @IBOutlet weak var playerOneScoreLabel: UILabel!
    @IBOutlet weak var playerTwoScoreLabel: UILabel!
    
    // playerOne is always the requestor
    // playerTwo is always the requestee
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
