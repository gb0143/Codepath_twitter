//
//  TwitterClient.swift
//  Twitter
//
//  Created by Yousef Kazerooni on 2/8/16.
//  Copyright © 2016 Yousef Kazerooni. All rights reserved.
//

import UIKit
import BDBOAuth1Manager
    
    let twitterBaseUrl = NSURL(string: "https://api.twitter.com")
    let twitterConsumerKey = "cX6MwQ1Wl8dTmPgkcvPBQM80B"
    let twitterConsumerSecret = "0LQmfesV3RoynCCJbg9u2Y0NVtgpzCAPx9NDTElsRAPoMIKyRX"
    
    class TwitterClient: BDBOAuth1SessionManager {
        
        //the variable will hold the closer that we will use 
        //in loginWithCompletion, till we are ready to use it
        var loginCompletion: ((user: User?, error: NSError?) -> ())?
        
        
        class var sharedInstance: TwitterClient {
            struct Static {
                static let instance = TwitterClient(
                    baseURL: twitterBaseUrl,
                    consumerKey: twitterConsumerKey,
                    consumerSecret: twitterConsumerSecret)
            }
            
            return Static.instance
        }
        
        func homeTimelineWithParams (params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
            GET( "1.1/statuses/home_timeline.json", parameters: params, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
                    //print("home_timeline: \(response!)")
                    
                    
                    //Minute 10:15 second video -- testing something out?
                    //More checking to see if the code works so far
                    var tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
                    completion(tweets: tweets, error: nil)
            
                }, failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                    print("error getting current user")
        completion(tweets: nil, error: error)
        
            })
        }
        
        
        
        //creating the completion method to be used in controllviewer
        func  loginWithCompletion(completion: (user: User?, error: NSError?) -> ()) {
            loginCompletion = completion
            
            //fetch my request token & redirect to authorization page
            //Initially we had this code on the viewController inside "onLogin"
            TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
            TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "cputwitterdemo://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
                print ("got the request token.")
                
                let authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
                
                UIApplication.sharedApplication().openURL(authURL!)
                
                }) { (error: NSError!) -> Void in
                    print ("failed to get request token.")
                    self.loginCompletion?(user: nil, error: error)
                    
                    
            }
            
        }
        
        func openURL(url: NSURL) {fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query), success: { (accessToken:BDBOAuth1Credential!) -> Void in
                print("Got the access token!")
                    
                TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
                TwitterClient.sharedInstance.GET("1.1/account/verify_credentials.json",parameters: nil,success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
                            //print("user: \(response!)")
                       var user = User(dictionary: response as! NSDictionary)
                            
                            //persisting the user as the current user
                        User.currentUser = user
                        print ("user: \(user.name)")
                        self.loginCompletion?(user: user, error: nil)},
                        failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                            print("error getting current user")
                            self.loginCompletion?(user: nil, error: error)
                    })
 
// *****moving the following code to the func homeTimelineWithParams above:
//                    TwitterClient.sharedInstance.GET(
//                        "1.1/statuses/home_timeline.json", parameters: nil, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
//                            //print("home_timeline: \(response!)")
//                            
//                            
//                            //Minute 10:15 second video -- testing something out?
//                            //More checking to see if the code works so far
//                            var tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
//                            
//                            for tweet in tweets {
//                                print ("text: \(tweet.text)") //still working on: created:tweet.createdAt
//                                
//                            }
//                        },
//                        failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
//                            print("error getting current user")
//                            
//                    })
                    
                },
                failure: { (error: NSError!) -> Void in
                    print("Failed to receive access token")
                    self.loginCompletion?(user: nil, error: error)
            })

        }
        
        func getUserBanner(id: Int, params: NSDictionary?, completion: (error: NSError?) -> () ){
            GET("1.1/users/profile_banner.json", parameters: params, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
                print("got user banner")
                completion(error: nil)
                }, failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                    print("did not get user banner")
                    completion(error: error)
                }
            )
        }
        
        //****************************************
        func userTweets(profileScreenName: String, params: NSDictionary?, completion: (error: NSError?) -> () ){
            GET("1.1/statuses/user_timeline.json", parameters: params, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
                print("tweets: \(response)")
                completion(error: nil)
                }, failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                    print("Couldn't find the tweets")
                    completion(error: error)
                }
            )
        }
        
        func reply(escapedTweet: String, statusID: Int, params: NSDictionary?, completion: (error: NSError?) -> () ){
            POST("1.1/statuses/update.json?in_reply_to_status_id=\(statusID)&status=\(escapedTweet)", parameters: params, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
                print("tweeted: \(escapedTweet)")
                completion(error: nil)
                }, failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                    print("Couldn't reply")
                    completion(error: error)
                }
            )
        }
        
        
        func compose(escapedTweet: String, params: NSDictionary?, completion: (error: NSError?) -> () ){
            POST("1.1/statuses/update.json?status=\(escapedTweet)", parameters: params, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
                print("tweeted: \(escapedTweet)")
                completion(error: nil)
                }, failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                    print("Couldn't compose")
                    completion(error: error)
                }
            )
        }
        
        //The following two fuctions
        //are curtsey of @r3dcrosse on gitHub
        func retweet(id: Int, params: NSDictionary?, completion: (error: NSError?) -> () ){
            POST("1.1/statuses/retweet/\(id).json", parameters: params, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
                print("Retweeted tweet with id: \(id)")
                completion(error: nil)
                }, failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                    print("Couldn't retweet")
                    completion(error: error)
                }
            )
        }
        
        func likeTweet(id: Int, params: NSDictionary?, completion: (error: NSError?) -> () ){
            POST("1.1/favorites/create.json?id=\(id)", parameters: params, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
                print("Liked tweet with id: \(id)")
                completion(error: nil)
                }, failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                    print("Couldn't like tweet")
                    completion(error: error)
                }
            )
        }
        

        
        
//
//        func unRetweet(id: Int, params: NSDictionary?, completion: (error: NSError?) -> () ){
//            POST("1.1/statuses/unretweet/\(id).json", parameters: params, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
//                print("Unretweeted tweet with id: \(id)")
//                completion(error: nil)
//                }, failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
//                    print("Couldn't unretweet")
//                    completion(error: error)
//                }
//            )
//        }
//        
//        func unLikeTweet(id: Int, params: NSDictionary?, completion: (error: NSError?) -> () ){
//            POST("1.1/favorites/destroy.json?id=\(id)", parameters: params, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
//                print("Unliked tweet with id: \(id)")
//                completion(error: nil)
//                }, failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
//                    print("Couldn't unlike tweet")
//                    completion(error: error)
//                }
//            )
//        }

        
    }



