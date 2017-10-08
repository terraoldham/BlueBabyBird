//
//  ProfileView.swift
//  BabyBird
//
//  Created by Terra Oldham on 10/7/17.
//  Copyright © 2017 HearsaySocial. All rights reserved.
//

import UIKit

class ProfileView: UIView {
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var taglineLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    
    var user: User! {
        didSet {
            profileImage.layer.cornerRadius = (profileImage.frame.width / 2)
            profileImage.layer.masksToBounds = true

            screennameLabel.text = user?.screenname
            taglineLabel.text = user?.description
            followingLabel.text = user?.followingCount?.description
            followersLabel.text = user?.followersCount?.description
            
            if user?.backgroundImageURL != nil {
                coverImage.setImageWith((user.backgroundImageURL)!)
            } else {
                coverImage.backgroundColor = UIColor(red: 0, green: 172/255, blue: 237/255, alpha: 1.0)
            }
        }
    }
}
