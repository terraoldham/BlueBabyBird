//
//  ProfileHeaderCell.swift
//  BabyBird
//
//  Created by Terra Oldham on 10/6/17.
//  Copyright © 2017 HearsaySocial. All rights reserved.
//

import UIKit

class ProfileHeaderCell: UITableViewCell {
    @IBOutlet weak var coverView: UIImageView!
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var followingCount: UILabel!
    @IBOutlet weak var followersCount: UILabel!
    
    var user: User!

    override func awakeFromNib() {
        super.awakeFromNib()
        photoView.layer.cornerRadius = (photoView.frame.width / 2)
        photoView.layer.masksToBounds = true
        
        
        print(user?.name)
        print(user?.description)
        screennameLabel.text = user?.screenname
        bioLabel.text = user?.description
        followingCount.text = user?.followingCount?.description
        followersCount.text = user?.followersCount?.description
        
        if user?.backgroundImageURL != nil {
            coverView.setImageWith((user.backgroundImageURL)!)
        } else {
            coverView.backgroundColor = UIColor(red: 0, green: 172/255, blue: 237/255, alpha: 1.0)
        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
