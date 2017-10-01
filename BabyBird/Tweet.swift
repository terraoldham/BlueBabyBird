//
//  Tweet.swift
//  BabyBird
//
//  Created by Terra Oldham on 9/26/17.
//  Copyright © 2017 HearsaySocial. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    
    var text: String?
    var timestamp: NSDate?
    var retweetCount: Int = 0
    var favoriteCount: Int = 0
    var sinceTweet: String?
    var user: User?
    var retweeted: Bool!
    var favorited: Bool!
    var idStr: String?
    var idInt: IntMax!
    
    init(dictionary: NSDictionary) {
        text = dictionary["text"] as? String
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoriteCount = (dictionary["favorite_count"] as? Int) ?? 0
        favorited = dictionary["favorited"] as! Bool!
        retweeted = dictionary["retweeted"] as! Bool!
        idStr = dictionary["id_str"] as? String
        idInt = dictionary["id"] as! IntMax!
        
        
        let timestampString = dictionary["created_at"] as? String
        
        if let timestampString = timestampString {
            let timestampString = dictionary["created_at"] as? String
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = formatter.date(from: timestampString!) as! NSDate
            sinceTweet = formatter.timeSince(from: timestamp!, numericDates: true)
        }

        
        if let user = dictionary["user"] as? NSDictionary {
            self.user = User(dictionary: user)
        }
        
    }
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        return tweets
    }
    
}

extension DateFormatter {
    /**
     Formats a date as the time since that date (e.g., “Last week, yesterday, etc.”).
     Adapted from: https://samoylov.eu/2016/09/19/implementing-time-since-function-in-swift-3/
     - Parameter from: The date to process.
     - Parameter numericDates: Determines if we should return a numeric variant, e.g. "1 month ago" vs. "Last month"
     - Returns: A string with formatted `date`.
     */
    func timeSince(from: NSDate, numericDates: Bool = false) -> String {
        let calendar = Calendar.current
        let now = NSDate()
        let earliest = now.earlierDate(from as Date)
        let latest = earliest == now as Date ? from : now
        let components = calendar.dateComponents([.year, .weekOfYear, .month, .day, .hour, .minute, .second], from: earliest, to: latest as Date)
        
        var result = ""
        
        if components.weekOfYear! >= 1 {
            result = "\(components.month!)" + "\(components.day!)" + "\(components.year!)"
        } else if components.day! >= 2 {
            result = "\(components.day!)d"
        } else if components.day! >= 1 {
            if numericDates {
                result = "1D"
            } else {
                result = "Yesterday"
            }
        } else if components.hour! >= 2 {
            result = "\(components.hour!)h"
        } else if components.hour! >= 1 {
            if numericDates {
                result = "1h"
            } else {
                result = "An h ago"
            }
        } else if components.minute! >= 2 {
            result = "\(components.minute!)m"
        } else if components.minute! >= 1 {
            if numericDates {
                result = "1m ago"
            } else {
                result = "A m ago"
            }
        } else if components.second! >= 3 {
            result = "\(components.second!)s"
        } else {
            result = "Just now"
        }
        return result
    }
}
