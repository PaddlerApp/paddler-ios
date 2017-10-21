//
//  ContactCell.swift
//  Paddler
//
//  Created by YingYing Zhang on 10/14/17.
//  Copyright © 2017 Paddler. All rights reserved.
//

import UIKit

class ContactCell: UITableViewCell {

    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var requestMatchButton: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
        profileImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
