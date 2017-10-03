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
        
        setImages()
        initializeTapGestures()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setImages() {
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
    }
    
    func initializeTapGestures() {
        let retweetTap = UITapGestureRecognizer(target: self, action: #selector(onRetweetTap(tapGestureRecognizer:)))
        retweetView.isUserInteractionEnabled = true
        retweetView.addGestureRecognizer(retweetTap)
        
        let favoriteTap = UITapGestureRecognizer(target: self, action: #selector(onFavoriteTap(tapGestureRecognizer:)))
        favoriteView.isUserInteractionEnabled = true
        favoriteView.addGestureRecognizer(favoriteTap)
        
        let replyTap = UITapGestureRecognizer(target: self, action: #selector(onReplyTap(tapGestureRecognizer:)))
        replyView.isUserInteractionEnabled = true
        replyView.addGestureRecognizer(replyTap)
    }
    
    @objc func onReplyTap(tapGestureRecognizer: UITapGestureRecognizer) {
        performSegue(withIdentifier: "replyToTweet", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "replyToTweet" {
            let nvc = segue.destination as! UINavigationController
            let cvc = nvc.topViewController as! ComposeViewController
            cvc.handleToReply = tweet.user?.screenname
            cvc.isReply = true
            cvc.replyId = tweet.idInt
        }
    }
    
    @objc func onRetweetTap(tapGestureRecognizer: UITapGestureRecognizer) {
        if retweeted == true {
            retweetView.image = UIImage(named: "grayretweet.png")
            retweeted = false
            let countBefore = tweet.retweetCount
            TwitterClient.sharedInstance?.unretweetTweet(IntMax(tweet.idInt!), success: { (tweet: Tweet) in
                print(tweet.retweetCount.description)
                if countBefore == tweet.retweetCount {
                    self.retweetCountLabel.text = (tweet.retweetCount - 1).description
                } else {
                    self.retweetCountLabel.text = tweet.retweetCount.description
                }
            }, failure: { (error: Error) in
                print((error.localizedDescription))
            })
        } else {
            retweetView.image = UIImage(named: "greenretweet")!
            retweeted = true
            let countBefore = tweet.retweetCount
            TwitterClient.sharedInstance?.retweetTweet(IntMax(tweet.idInt!), success: { (tweet: Tweet) in
                if countBefore == tweet.retweetCount {
                    self.retweetCountLabel.text = (tweet.retweetCount + 1).description
                } else {
                    self.retweetCountLabel.text = tweet.retweetCount.description
                }
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
                    self.likeCountLabel.text = (tweet.favoriteCount - 1).description
                } else {
                    self.likeCountLabel.text = tweet.favoriteCount.description
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
                    self.likeCountLabel.text = (tweet.favoriteCount + 1).description
                } else {
                    self.likeCountLabel.text = tweet.favoriteCount.description
                }
            }, failure: { (error: Error) in
                print((error.localizedDescription))
            })
        }
    }


}
