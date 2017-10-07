//
//  TwitterClient.swift
//  BabyBird
//
//  Created by Terra Oldham on 9/27/17.
//  Copyright © 2017 HearsaySocial. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    
    static let sharedInstance = TwitterClient(baseURL: URL(string: "https://api.twitter.com"), consumerKey: "xdn221RrVQHYhd4uw96iKQp12", consumerSecret: "r9zAJ8PFKamr3wANygXowpwi8MpAu1PrOz17dng5z7d3eEiYyw")
    
    func currentAccount(success: @escaping (User) -> (), failure: @escaping (Error) -> ()) {
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) -> Void in
            let userDictionary = response as! NSDictionary
            let user = User(dictionary: userDictionary)
            success(user)
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })

    }
    
    
    func homeTimeline(success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
        get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) -> Void in
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
            print(dictionaries[0])
            success(tweets)
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
        
    }
    
    func homeTimelineMoreTweets(_ sinceId: IntMax!, success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
        let parameters = ["sinceId": sinceId as AnyObject]
        get("1.1/statuses/home_timeline.json", parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, response: Any?) -> Void in
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
            print(dictionaries[0])
            success(tweets)
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
        
    }
    
    func publishTweet(_ status: String, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()) {
        let parameters = ["status": status as AnyObject]
        post("/1.1/statuses/update.json", parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, response: Any?) -> Void in
            let dictionary = response as! NSDictionary
            let tweet = Tweet(dictionary: dictionary)
            success(tweet)
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
        
    }
    
    func publishResponseTweet(_ status: String, in_reply_to_status_id: IntMax, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()) {
        let parameters = ["status": status as AnyObject, "in_reply_to_status_id": in_reply_to_status_id] as [String : Any]
        post("/1.1/statuses/update.json", parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, response: Any?) -> Void in
            let dictionary = response as! NSDictionary
            let tweet = Tweet(dictionary: dictionary)
            success(tweet)
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
        
    }
    
    func likeTweet(id: IntMax, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()) {
        post("/1.1/favorites/create.json", parameters: ["id": id], progress: nil, success: { (task: URLSessionDataTask, response: Any?) -> Void in
            let dictionary = response as! NSDictionary
            let tweet = Tweet(dictionary: dictionary)
            success(tweet)
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
        
    }
    
    func unlikeTweet(id: IntMax, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()) {
        post("/1.1/favorites/destroy.json", parameters: ["id": id], progress: nil, success: { (task: URLSessionDataTask, response: Any?) -> Void in
            let dictionary = response as! NSDictionary
            let tweet = Tweet(dictionary: dictionary)
            success(tweet)
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
        
    }
    
    func retweetTweet(_ id: IntMax, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()) {
        let retweet_string = "/1.1/statuses/retweet/\(id).json" as String!
        post(retweet_string!, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) -> Void in
            let dictionary = response as! NSDictionary
            let tweet = Tweet(dictionary: dictionary)
            success(tweet)
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
        
    }
    
    func unretweetTweet(_ id: IntMax, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()) {
        let unretweet_string = "/1.1/statuses/unretweet/\(id).json" as String!
        post(unretweet_string!, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) -> Void in
            let dictionary = response as! NSDictionary
            let tweet = Tweet(dictionary: dictionary)
            success(tweet)
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
        
    }
    
    func mentionsTimeline(username: String?, success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
        var params: [String: AnyObject] = [:]
        params["screen_name"] = username as AnyObject
        
        get("1.1/statuses/mentions_timeline.json", parameters: params, progress: nil, success: { (task: URLSessionDataTask, response: Any?) -> Void in
            let dictionaries = response as! [NSDictionary]
            
            let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
            
            success(tweets)
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
        
    }
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((Error) -> ())?
    
    func login(success: @escaping ()->(), failure: @escaping (Error)->()) {
        loginSuccess = success
        loginFailure = failure
        
        TwitterClient.sharedInstance?.deauthorize()
        TwitterClient.sharedInstance?.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string: "bluebabybird://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            print("I got a token!")
            let url = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=" + requestToken.token)
            UIApplication.shared.open(url!)
            
        }, failure: { (error: Error!) -> Void in
            print("error : \(error.localizedDescription)")
            self.loginFailure?(error)
        })
    }
    
    func logout() {
        User.currentUser = nil
        deauthorize()
        
        NotificationCenter.default.post(name: NSNotification.Name(User.userDidLogoutNotification), object: nil, userInfo: [:])
    }
    
    func handleOpenUrl(url: URL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential!) -> Void in
            print("I got an access token!")
            
            self.currentAccount(success: { (user: User) in
                User.currentUser = user
                self.loginSuccess?()
            }, failure: { (error: Error) in
                self.loginFailure?(error)
            })

        }, failure: { (error: Error!) -> Void in
            print("error : \(error.localizedDescription)")
            self.loginFailure?(error)
        })
        
    }

}
