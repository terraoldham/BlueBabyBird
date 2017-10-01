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
    @IBOutlet weak var retweetCount: UILabel!
    @IBOutlet weak var favoriteCount: UILabel!
    @IBOutlet weak var retweetView: UIImageView!
    @IBOutlet weak var favoriteView: UIImageView!
    
    var retweeted: Bool = false
    var favorited: Bool = false
    
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
            favoriteCount.text = tweet.favoriteCount.description
            retweetCount.text = tweet.retweetCount.description
            
            if retweeted == false {
                retweetView.image = UIImage(named: "grayretweet.png")!
            } else {
                retweetView.image = UIImage(named: "greenretweet")
            }
            
            if favorited == false {
                favoriteView.image = UIImage(named: "grayheart.png")!
            } else {
                favoriteView.image = UIImage(named: "pinkheart")
            }
            
            initializeTapGestures()
            
        }
    }
    
    func initializeTapGestures() {
        let retweetTap = UITapGestureRecognizer(target: self, action: #selector(onRetweetTap(tapGestureRecognizer:)))
        retweetView.isUserInteractionEnabled = true
        retweetView.addGestureRecognizer(retweetTap)
        let favoriteTap = UITapGestureRecognizer(target: self, action: #selector(onFavoriteTap(tapGestureRecognizer:)))
        favoriteView.isUserInteractionEnabled = true
        favoriteView.addGestureRecognizer(favoriteTap)
    }
    
    @objc func onRetweetTap(tapGestureRecognizer: UITapGestureRecognizer) {
        if retweeted == true {
            retweetView.image = UIImage(named: "grayretweet.png")
            retweeted = false
            let countBefore = tweet.retweetCount
            TwitterClient.sharedInstance?.unretweetTweet(IntMax(tweet.idInt!), success: { (tweet: Tweet) in
                if countBefore == tweet.retweetCount {
                    self.retweetCount.text = (tweet.retweetCount - 1).description
                } else {
                    self.retweetCount.text = tweet.retweetCount.description
                }
                print(tweet.retweetCount.description)
            }, failure: { (error: Error) in
                print((error.localizedDescription))
            })
        } else {
            retweetView.image = UIImage(named: "greenretweet")!
            retweeted = true
            let countBefore = tweet.retweetCount
            TwitterClient.sharedInstance?.retweetTweet(IntMax(tweet.idInt!), success: { (tweet: Tweet) in
                if countBefore == tweet.retweetCount {
                    self.retweetCount.text = (tweet.retweetCount + 1).description
                } else {
                    self.retweetCount.text = tweet.retweetCount.description
                }
                print(tweet.retweetCount.description)
            }, failure: { (error: Error) in
                print((error.localizedDescription))
            })
        }
        
    }
    
    @objc func onFavoriteTap(tapGestureRecognizer: UITapGestureRecognizer) {
        if favorited == true {
            favoriteView.image = UIImage(named: "grayheart.png")
            favorited = false
            let countBefore = tweet.favoriteCount
            TwitterClient.sharedInstance?.unlikeTweet(id: IntMax(tweet.idInt), success: { (tweet: Tweet) in
                if countBefore == tweet.favoriteCount {
                    self.favoriteCount.text = (tweet.favoriteCount - 1).description
                } else {
                    self.favoriteCount.text = tweet.favoriteCount.description
                }
            }, failure: { (error: Error) in
                print((error.localizedDescription))
            })
        } else {
            favoriteView.image = UIImage(named: "pinkheart")!
            favorited = true
            let countBefore = tweet.favoriteCount
            TwitterClient.sharedInstance?.likeTweet(id: IntMax(tweet.idInt), success: { (tweet: Tweet) in
                if countBefore == tweet.favoriteCount {
                    self.favoriteCount.text = (tweet.favoriteCount + 1).description
                } else {
                    self.favoriteCount.text = tweet.favoriteCount.description
                }
                print(tweet.favoriteCount.description)
            }, failure: { (error: Error) in
                print((error.localizedDescription))
            })
        }
    }
    
    
    
    

}
