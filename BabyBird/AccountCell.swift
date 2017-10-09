//
//  AccountCellTableViewCell.swift
//  BabyBird
//
//  Created by Terra Oldham on 10/8/17.
//  Copyright © 2017 HearsaySocial. All rights reserved.
//

import UIKit

class AccountCell: UITableViewCell {
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var screennameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    var account: User! {
        didSet {
            profileImage.setImageWith(account.profileUrl!)
            profileImage.layer.cornerRadius = (profileImage.frame.width / 2)
            profileImage.layer.masksToBounds = true
            screennameLabel.text = account.screenname
        }
    }

}
