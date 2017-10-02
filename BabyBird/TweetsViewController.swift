//
//  TweetsViewController.swift
//  BabyBird
//
//  Created by Terra Oldham on 9/28/17.
//  Copyright © 2017 HearsaySocial. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, ComposeViewControllerDelegate {
    @IBOutlet weak var tableView: UITableView!


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
        
        TwitterClient.sharedInstance?.homeTimeline(success: { (tweets: [Tweet]) in
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollViewContentHeight = tableView.contentSize.height
        let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
        
        if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
            isMoreDataLoading = true
            loadMoreData()
        }
    }
    
    func composeViewController(composeViewController: ComposeViewController, tweet: Tweet) {
        self.tweets.insert(tweet, at: 0)
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logoutButton(_ sender: Any) {
        TwitterClient.sharedInstance?.logout()
    }
    
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        
        TwitterClient.sharedInstance?.homeTimeline(success: { (tweets: [Tweet]) in
            self.tweets = tweets
            refreshControl.endRefreshing()
            self.tableView.reloadData()
        }, failure: { (error: Error) in
            print(error.localizedDescription)
        })
    }
    
    func loadMoreData() {
        let lastId = self.tweets.last!.idInt!
        TwitterClient.sharedInstance?.homeTimelineMoreTweets(lastId, success: { (tweets: [Tweet]) in
            self.tweets = self.tweets + tweets
            self.isMoreDataLoading = false
            self.tableView.reloadData()
        }, failure: { (error: Error) in
            print(error.localizedDescription)
        })
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? DetailsViewController {
            let cell = sender as! UITableViewCell!
            let indexPath = tableView.indexPath(for: cell!)!
            let tweet = self.tweets[indexPath.row]
            vc.tweet = tweet
        }
        if let nvc = segue.destination as? UINavigationController {
            let cvc = nvc.viewControllers.first as! ComposeViewController
            cvc.delegate = self
        }
    }

    @IBAction func onComposeButton(_ sender: Any) {
    }
    
    @IBAction func onMenuClick(_ sender: Any) {
        let buttonPosition:CGPoint = (sender as AnyObject).convert(CGPoint(x: 0,y :0), to:self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: buttonPosition)
        let tweet = self.tweets[(indexPath?.row)!]
        tweetedFrom = tweet.user?.screenname as String!

        let ac = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Share Tweet Via...", style: .default, handler: { (action) in
            // Action items here
        }))
        ac.addAction(UIAlertAction(title: "Add to Moment", style: .default, handler: { (action) in
            // Action items here
        }))
        ac.addAction(UIAlertAction(title: "I don't like this Tweet", style: .default, handler: { (action) in
            // Action items here
        }))
        ac.addAction(UIAlertAction(title: "Follow @" + tweetedFrom, style: .default, handler: { (action) in
            // Action items here
        }))
        ac.addAction(UIAlertAction(title: "Mute @" + tweetedFrom, style: .default, handler: { (action) in
            // Action items here
        }))
        ac.addAction(UIAlertAction(title: "Block @" + tweetedFrom, style: .default, handler: { (action) in
            // Action items here
        }))
        ac.addAction(UIAlertAction(title: "Report Tweet", style: .default, handler: { (action) in
            // Action items here
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(ac, animated: true, completion: nil)
    }

}
