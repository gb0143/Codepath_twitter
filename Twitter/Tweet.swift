//
//  Tweet.swift
//  Twitter
//
//  Created by Gaurang Bhatt on 2/11/16.
//  Copyright © 2016 Gaurang Bhatt. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var user: User?
    var text: String?
    var createdAtString: String?
    var createdAt: NSDate?
    
    //favorites and retweets
    var id: String
    var retweetCount: Int?
    var likeCount: Int?
    
    init(dictionary: NSDictionary) {
        user = User(dictionary: dictionary["user"] as! NSDictionary)
        text = dictionary["text"] as? String
        createdAtString = dictionary["created_at"] as? String
        
        //The time is given as greenich mean time, and we need to parse it
        //We use the documentation for NSFormatter, and twitter's guidlines
        var formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        createdAt = formatter.dateFromString(createdAtString!)
        
        
        id = String (dictionary["id"]!)
        retweetCount = dictionary["retweet_count"] as? Int
        likeCount = dictionary["favorite_count"] as? Int
        
        
    }
    
    //Convenience method that parses an array of tweets
    class func tweetsWithArray (array: [NSDictionary]) ->[Tweet]{
        var tweets = [Tweet]()
        
        for dictionary in array {
            tweets.append(Tweet(dictionary: dictionary))
        }
        
        return tweets
    }

}
