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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
