//
//  MentionsViewController.swift
//  BabyBird
//
//  Created by Terra Oldham on 10/4/17.
//  Copyright © 2017 HearsaySocial. All rights reserved.
//

import UIKit

class MentionsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, ComposeViewControllerDelegate {
    @IBOutlet var tableView: UITableView!
    
    var user = User.currentUser!
    var tweets: [Tweet]!
    var isMoreDataLoading = false
    var tweetedFrom: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        TwitterClient.sharedInstance?.mentionsTimeline(username: user.screenname, success: { (tweets: [Tweet]) in
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
        TwitterClient.sharedInstance?.mentionsTimelineMoreTweets(username: user.screenname, sinceId: lastId, success: { (tweets: [Tweet]) in
            self.tweets = self.tweets + tweets
            self.isMoreDataLoading = false
            self.tableView.reloadData()
        }, failure: { (error: Error) in
            print(error.localizedDescription)
        })
    }
    
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        TwitterClient.sharedInstance?.mentionsTimeline(username: user.screenname, success: { (tweets: [Tweet]) in
            self.tweets = tweets
            refreshControl.endRefreshing()
            self.tableView.reloadData()
        }, failure: { (error: Error) in
            print(error.localizedDescription)
        })
    }

}
