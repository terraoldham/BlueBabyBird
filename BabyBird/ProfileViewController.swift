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
    
    var user: User! = User.currentUser
    var tweets: [Tweet]!
    var tweetedFrom: String!
    var screenname: String! = User.currentUser?.screenname

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
        
        TwitterClient.sharedInstance?.userTimeline(username: screenname, success: { (tweets: [Tweet]) in
            self.tweets = tweets
            self.tableView.reloadData()
        }, failure: { (error: Error) in
            print(error.localizedDescription)
        })
        

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
        print(screenname)
        TwitterClient.sharedInstance?.userTimeline(username: screenname, success: { (tweets: [Tweet]) in
            self.tweets = tweets
            refreshControl.endRefreshing()
            self.tableView.reloadData()
        }, failure: { (error: Error) in
            print(error.localizedDescription)
        })
    }

}
