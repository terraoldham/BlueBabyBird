//
//  TweetCell.swift
//  BabyBird
//
//  Created by Terra Oldham on 9/28/17.
//  Copyright © 2017 HearsaySocial. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {

    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var photoView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        photoView.layer.cornerRadius = (photoView.frame.width / 2)
        photoView.layer.masksToBounds = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var tweet: Tweet! {
        didSet {
            tweetTextLabel.text = tweet.text
            screennameLabel.text = "@" + (tweet.user?.screenname)!
            nameLabel.text = tweet.user?.name
            timestampLabel.text = tweet.sinceTweet!
            photoView.setImageWith((tweet.user?.profileUrl)!)
        }
    }

}
