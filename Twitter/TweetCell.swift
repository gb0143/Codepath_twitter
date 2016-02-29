//
//  TweetCell.swift
//  Twitter
//
//  Created by Gaurang Bhatt on 2/13/16.
//  Copyright © 2016 Gaurang Bhatt. All rights reserved.
//

import UIKit
import AFNetworking


class TweetCell: UITableViewCell {

    
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var userNameHandle: UILabel!
    
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var retweetLabel: UILabel!
    @IBOutlet weak var favoriteLabel: UILabel!
    
    
    var tweetID: String = ""
    
    var tweet: Tweet! {
        
        
        didSet {
           userNameLabel.text = "\((tweet.user?.name)!)"
           userNameHandle.text = "@" + "\((tweet.user?.screenname)!)"
           tweetTextLabel.text = tweet.text
           //dateLabel.text = "\(tweet.createdAt!)"
           dateLabel.text = calculateTimeStamp(tweet.createdAt!.timeIntervalSinceNow)
            
            //Retrieving the image
            let imageUrl = tweet.user?.profileImageUrl!
            profilePictureImageView.setImageWithURL(NSURL(string: imageUrl!)!)
            
            
// Another way of saying the code above
//            if let user = tweet.user {
//                userNameLabel.text = "\(tweet.user!)"
//            }
            
            
            tweetID = tweet.id
            retweetLabel.text = String(tweet.retweetCount!)
            favoriteLabel.text = String(tweet.likeCount!)
            
            retweetLabel.text! == "0" ? (retweetLabel.hidden = true) : (retweetLabel.hidden = false)
            favoriteLabel.text! == "0" ? (favoriteLabel.hidden = true) : (favoriteLabel.hidden = false)
            

        }
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
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //to make the profile image have rounded side instead of sharp edges
        profilePictureImageView.layer.cornerRadius = 3
        profilePictureImageView.clipsToBounds = true
        
//doesn't seem to care About My size constraints
//        userNameLabel.preferredMaxLayoutWidth = userNameLabel.frame.size.width
//        dateLabel.preferredMaxLayoutWidth = 67
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  
    
    
    //The two following fuctions are curtsey of @r3dcrosse from gitHub
    
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
    

    
    

}
