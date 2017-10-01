//
//  DetailsViewController.swift
//  BabyBird
//
//  Created by Terra Oldham on 9/29/17.
//  Copyright © 2017 HearsaySocial. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var replyView: UIImageView!
    @IBOutlet weak var retweetView: UIImageView!
    @IBOutlet weak var favoriteView: UIImageView!
    @IBOutlet weak var messageView: UIImageView!
    
    var favorited: Bool = false
    var retweeted: Bool = false
    
    var tweet: Tweet!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        photoView.layer.cornerRadius = (photoView.frame.width / 2)
        photoView.layer.masksToBounds = true
        
        textLabel.text = tweet.text
        handleLabel.text = "@" + (tweet.user?.screenname)!
        nameLabel.text = tweet.user?.name
        timestampLabel.text = tweet.sinceTweet!
        photoView.setImageWith((tweet.user?.profileUrl)!)
        retweetCountLabel.text = tweet.retweetCount.description
        likeCountLabel.text = tweet.favoriteCount.description
        
        favorited = tweet.favorited
        retweeted = tweet.retweeted
        
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            TwitterClient.sharedInstance?.unretweetTweet(IntMax(tweet.idInt!), success: { (tweet: Tweet) in
                self.retweetCountLabel.text = tweet.retweetCount.description
                print(tweet.retweetCount.description)
            }, failure: { (error: Error) in
                print((error.localizedDescription))
            })
        } else {
            retweetView.image = UIImage(named: "greenretweet")!
            retweeted = true
            TwitterClient.sharedInstance?.retweetTweet(IntMax(tweet.idInt!), success: { (tweet: Tweet) in
                self.retweetCountLabel.text = tweet.retweetCount.description
                print(tweet.retweetCount.description)
            }, failure: { (error: Error) in
                print((error.localizedDescription))
            })
        }
        
    }
    
    @objc func onFavoriteTap(tapGestureRecognizer: UITapGestureRecognizer) {
        if favorited == true {
            favoriteView.image = UIImage(named: "grayheart.png")
            favorited = true
            TwitterClient.sharedInstance?.unlikeTweet(id: IntMax(tweet.idInt), success: { (tweet: Tweet) in
                self.likeCountLabel.text = tweet.favoriteCount.description
                print(tweet.favoriteCount.description)
            }, failure: { (error: Error) in
                print((error.localizedDescription))
            })
        } else {
            favoriteView.image = UIImage(named: "pinkheart")!
            favorited = false
            TwitterClient.sharedInstance?.unlikeTweet(id: IntMax(tweet.idInt), success: { (tweet: Tweet) in
                self.likeCountLabel.text = tweet.favoriteCount.description
                print(tweet.favoriteCount.description)
            }, failure: { (error: Error) in
                print((error.localizedDescription))
            })
        }
    }

}
