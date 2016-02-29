//
//  User.swift
//  Twitter
//
//  Created by Gaurang Bhatt on 2/11/16.
//  Copyright © 2016 Gaurang Bhatt. All rights reserved.
//

import UIKit


let currentUserKey = "kCurrentUserKey"
let userDidLoginNotification = "userDidLoginNotification"
let userDidLogoutNotification = "userDidLogoutNotification"
//Hacking the currentUser class
var _currentUser: User?


class User: NSObject {
    var name: String?
    var screenname: String?
    var profileImageUrl: String?
    var bannerImageUrl: NSURL?
    var tagline: String?
    //for fun we will also include the actual dictionary
    var dictionary: NSDictionary
    var statusesCount: Int
    var followersTotal: Int
    var followingTotal: Int
    var userID: Int
    
    init( dictionary: NSDictionary) {
        self.dictionary = dictionary
        
        name = dictionary["name"] as? String
        screenname = dictionary["screen_name"] as? String
        profileImageUrl = dictionary["profile_image_url"] as? String
        tagline = dictionary["description"] as? String
        userID = dictionary["id"] as! Int
        followersTotal = dictionary["followers_count"] as! Int
        followingTotal = dictionary["friends_count"] as! Int
        statusesCount = dictionary["statuses_count"] as! Int
        
        let banner = dictionary["profile_background_image_url_https"] as? String
        if banner != nil {
            bannerImageUrl = NSURL(string: banner!)!
        }
    }
    
    func logout() {
        User.currentUser = nil
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        
        NSNotificationCenter.defaultCenter().postNotificationName(userDidLogoutNotification, object: nil)
    }
    
//    //For Persistence, so that the app remembers the user
//    class var currentUser: User? {
//        get{
//            return _currentUser
//        }
//        set(user){
//            _currentUser = user
//            
//            //Now persisting the user with NSCoding
//            //we will cheat by using the dictionary var
//            //which is a JASON
//            if _currentUser != nil{
//                var data = NSJSONSerialization.dataWithJSONObject(<#T##obj: AnyObject##AnyObject#>, options: <#T##NSJSONWritingOptions#>)
//            } else {
//                
//            }
//            
//            
//            
//        }
//    }
    
    class var currentUser: User? {
        
        get {
        if _currentUser == nil {
        //logged out or just boot up
        let data = NSUserDefaults.standardUserDefaults().objectForKey(currentUserKey) as? NSData
        if data != nil {
        let dictionary: NSDictionary?
        do {
        try dictionary = NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSDictionary
        _currentUser = User(dictionary: dictionary!)
    } catch {
        print(error)
        }
      }
    }
    return _currentUser
   }
        
        set(user) {
            _currentUser = user
            //User need to implement NSCoding; but, JSON also serialized by default
            if let _ = _currentUser {
                var data: NSData?
                do {
                    try data = NSJSONSerialization.dataWithJSONObject(user!.dictionary, options: .PrettyPrinted)
                    NSUserDefaults.standardUserDefaults().setObject(data, forKey: currentUserKey)
                } catch {
                    print(error)
                }
            } else {
                //Clear the currentUser data
                NSUserDefaults.standardUserDefaults().setObject(nil, forKey: currentUserKey)
            }
        }
    }

}
