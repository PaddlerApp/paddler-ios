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
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
