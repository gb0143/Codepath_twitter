//
//  DetailsViewController.swift
//  Twitter
//
//  Created by Yousef Kazerooni on 2/25/16.
//  Copyright © 2016 Yousef Kazerooni. All rights reserved.
//

import UIKit
import AFNetworking


class DetailsViewController: UIViewController {
    
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var userNameHandle: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var favoriteLabel: UILabel!
    
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var retweetLabel: UILabel!
    
    
    
    var tweetID: String = ""
    
    //var tweetCell: TweetCell!
    var tweet: Tweet!



    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        print("\(tweet)")
        userNameLabel.text = "\((tweet.user?.name)!)"
        userNameHandle.text = "@" + "\((tweet.user?.screenname)!)"
        tweetTextLabel.text = tweet.text
        dateLabel.text = calculateTimeStamp(tweet.createdAt!.timeIntervalSinceNow)
        
        
        //Retrieving the image
        let imageUrl = tweet.user?.profileImageUrl!
        profilePictureImageView.setImageWithURL(NSURL(string: imageUrl!)!)
        
        
        
        tweetID = tweet.id
        retweetLabel.text = String(tweet.retweetCount!)
        favoriteLabel.text = String(tweet.likeCount!)
        
        retweetLabel.text! == "0" ? (retweetLabel.hidden = true) : (retweetLabel.hidden = false)
        favoriteLabel.text! == "0" ? (favoriteLabel.hidden = true) : (favoriteLabel.hidden = false)
    

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //This function is curtsey of @r3dcrosse
    func calculateTimeStamp(timeTweetPostedAgo: NSTimeInterval) -> String {
        // Turn timeTweetPostedAgo into seconds, minutes, hours, days, or years
        var rawTime = Int(timeTweetPostedAgo)
        var timeAgo: Int = 0
        var timeChar = ""
        
        rawTime = rawTime * (-1)
        
        // Figure out time ago
        if (rawTime <= 60) { // SECONDS
            timeAgo = rawTime
            timeChar = "s"
        } else if ((rawTime/60) <= 60) { // MINUTES
            timeAgo = rawTime/60
            timeChar = "m"
        } else if (rawTime/60/60 <= 24) { // HOURS
            timeAgo = rawTime/60/60
            timeChar = "h"
        } else if (rawTime/60/60/24 <= 365) { // DAYS
            timeAgo = rawTime/60/60/24
            timeChar = "d"
        } else if (rawTime/(3153600) <= 1) { // YEARS
            timeAgo = rawTime/60/60/24/365
            timeChar = "y"
        }
        
        return "\(timeAgo)\(timeChar)"
    }
    
    

    
    
    @IBAction func onLike(sender: AnyObject) {
        
        TwitterClient.sharedInstance.likeTweet(Int(tweetID)!, params: nil, completion: {(error) -> () in
            self.favoriteButton.setImage(UIImage(named: "like-action-on"), forState: UIControlState.Selected)
            
            if self.favoriteLabel.text! > "0" {
                self.favoriteLabel.text = String(self.tweet.likeCount! + 1)
            } else {
                self.favoriteLabel.hidden = false
                self.favoriteLabel.text = String(self.tweet.likeCount! + 1)
            }
        })
    }
    
    
    
    @IBAction func onRetweet(sender: AnyObject) {
        
        TwitterClient.sharedInstance.retweet(Int(tweetID)!, params: nil, completion: {(error) -> () in
            self.retweetButton.setImage(UIImage(named: "retweet-action-on"), forState: UIControlState.Selected)
            
            if self.retweetLabel.text! > "0" {
                self.retweetLabel.text = String(self.tweet.retweetCount! + 1)
            } else {
                self.retweetLabel.hidden = false
                self.retweetLabel.text = String(self.tweet.retweetCount! + 1)
            }
        })
    }



    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier) == "SegueToReply" {
            let user = User.currentUser
            let tweet = self.tweet
            
            let composeController = segue.destinationViewController as! ComposeController
            composeController.user = user
            composeController.tweet = tweet
            composeController.userNameHandleText = (user?.screenname)!
            composeController.isReply = true
        } else {
            
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
