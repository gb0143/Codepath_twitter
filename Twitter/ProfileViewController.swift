//
//  ProfileViewController.swift
//  Twitter
//
//  Created by Yousef Kazerooni on 2/28/16.
//  Copyright © 2016 Yousef Kazerooni. All rights reserved.
//

import UIKit
import AFNetworking

class ProfileViewController: UIViewController {
    
    
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userNameHandleLabel: UILabel!
    @IBOutlet weak var tweetsToatlLabel: UILabel!
    @IBOutlet weak var followingTotalLabel: UILabel!
    @IBOutlet weak var followersTotalLabel: UILabel!
    
    var user: User?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageUrl = (user?.profileImageUrl!)!
        profilePictureImageView.setImageWithURL(NSURL(string: imageUrl)!)
        
        
        
        //let banner = (user?.bannerImageUrl!)!
        bannerImageView.setImageWithURL((user?.bannerImageUrl!)!)
        
        
        userNameLabel.text = user?.name
        userNameHandleLabel.text = "@\((user?.screenname)!)"
        tweetsToatlLabel.text = String(user!.statusesCount)
        followingTotalLabel.text = String(user!.followingTotal)
        followersTotalLabel.text = String(user!.followersTotal)
        
        
//        let profileScreenName = user?.screenname!
//        
//        TwitterClient.sharedInstance.userTweets( profileScreenName!, params: nil) { (error) -> () in
//            
//        }
        
        
        //let userID = user?.userID
//        let banner = TwitterClient.sharedInstance.getUserBanner(userID!, params: nil) { (error) -> () in
//            
//        }
//        print("banner for \(user!.name!) is here: \(banner)")
//        

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
 
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
