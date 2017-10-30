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
    
    var contact: PaddlerUser! {
        didSet {
            updateViews()
        }
    }
    
    private func updateViews() {
        playerNameLabel.text = contact.fullName!
        if let url = contact.profileURL {
            self.profileImageView.setImageWith(url)
        } else {
            self.profileImageView.image = UIImage(named:"people-placeholder.png")
        }
        selectionStyle = .none // get rid of gray selection
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
        profileImageView.clipsToBounds = true
        
        requestMatchButton.layer.cornerRadius = 5
        requestMatchButton.layer.shadowColor = UIColor(red:0.18, green:0.49, blue:0.20, alpha:1.0).cgColor
        //requestMatchButton.layer.borderWidth = 1
        //requestMatchButton.layer.borderColor = UIColor(red:0.18, green:0.49, blue:0.20, alpha:1.0).cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
