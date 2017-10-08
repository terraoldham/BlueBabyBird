//
//  ProfileViewController.swift
//  BabyBird
//
//  Created by Terra Oldham on 10/4/17.
//  Copyright © 2017 HearsaySocial. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController,  UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, ComposeViewControllerDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var coverPhoto: UIImageView!
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var followingCount: UILabel!
    @IBOutlet weak var taglineLabel: UILabel!
    @IBOutlet weak var followersCount: UILabel!
    @IBOutlet weak var totalView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    var user: User! = User.currentUser
    var tweets: [Tweet]!
    var tweetedFrom: String!
    var isMoreDataLoading = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "ProfileView")
        
        TwitterClient.sharedInstance?.userTimeline(username: user.screenname, success: { (tweets: [Tweet]) in
            self.tweets = tweets
            self.tableView.reloadData()
        }, failure: { (error: Error) in
            print(error.localizedDescription)
        })
        
        nameLabel.text = user.name
        screennameLabel.text = "@" + user.screenname!
        followingCount.text = user.followingCount?.description
        followersCount.text = user.followersCount?.description
        taglineLabel.text = user.tagline
        coverPhoto.setImageWith(user.backgroundImageURL!)
        profilePhoto.setImageWith(user.profileUrl!)
        
        profilePhoto.layer.cornerRadius = (profilePhoto.frame.width / 2)
        profilePhoto.layer.masksToBounds = true

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
        cell.tweet = tweets![indexPath.row]
        print(tweets![indexPath.row])
        return cell
    }
    
    func composeViewController(composeViewController: ComposeViewController, tweet: Tweet) {
        self.tweets.insert(tweet, at: 0)
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        TwitterClient.sharedInstance?.userTimeline(username: user.screenname, success: { (tweets: [Tweet]) in
            self.tweets = tweets
            refreshControl.endRefreshing()
            self.tableView.reloadData()
        }, failure: { (error: Error) in
            print(error.localizedDescription)
        })
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollViewContentHeight = tableView.contentSize.height
        let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
        
        if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
            isMoreDataLoading = true
            loadMoreData()
            
        }
    }
    
    func loadMoreData() {
        let lastId = self.tweets.last!.idInt!
        TwitterClient.sharedInstance?.userTimelineMoreTweets(username: user.screenname, sinceId: lastId, success: { (tweets: [Tweet]) in
            self.tweets = self.tweets + tweets
            self.isMoreDataLoading = false
            self.tableView.reloadData()
        }, failure: { (error: Error) in
            print(error.localizedDescription)
        })
    }

}
