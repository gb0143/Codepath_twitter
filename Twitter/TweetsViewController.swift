//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Yousef Kazerooni on 2/13/16.
//  Copyright © 2016 Yousef Kazerooni. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    var tweets: [Tweet]?
    var refreshControl: UIRefreshControl!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        apiNetworkRequest()
        
        // Initialize a UIRefreshControl
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
       
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func onLogout(sender: AnyObject) {
        User.currentUser?.logout()
    }
    
    
    func apiNetworkRequest () {
        TwitterClient.sharedInstance.homeTimelineWithParams(nil) { (tweets, error) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
            
        }
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        if tweets != nil {
            return tweets!.count
        } else {
            return 0
        }
        
    }
    
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
       let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetCell
        
        cell.tweet = tweets![indexPath.row]
        
        return cell
    }
    
    //**********2 RefreshControl
    func refreshControlAction(refreshControl: UIRefreshControl) {
        
        
        // Make network request to fetch latest data
        apiNetworkRequest()
        // Do the following when the network request comes back successfully:
        // Update tableView data source
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
   
    
    


    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    
        if (segue.identifier == "SegueToDetails") {
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPathForCell(cell)
            let tweet = tweets![indexPath!.row]
            
            let tweetDetailViewController = segue.destinationViewController as! DetailsViewController
            tweetDetailViewController.tweet = tweet
        }
        else if (segue.identifier) == "SegueToCompose" {
            
            let user = User.currentUser
            
            let composeTweetViewController = segue.destinationViewController as! ComposeController
            composeTweetViewController.user = user
        }
        
        
        else if (segue.identifier) == "SegueToProfile" {
            
            
            let button = sender as! UIButton
            let view = button.superview!
            let cell = view.superview as! TweetCell
            
            let indexPath = tableView.indexPathForCell(cell)
            let tweet = tweets![indexPath!.row]
            let user = tweet.user
            
            let profileViewController = segue.destinationViewController as! ProfileViewController
            profileViewController.user = user
            
        }

//        let cell = sender as! UITableViewCell
//        let indexpath = tableView.indexPathForCell(cell)
//        let tweet = tweets![indexpath!.row] 
//        
//        let detailsViewController = segue.destinationViewController as! DetailsViewController
//        detailsViewController.tweet = tweet
        
        
    
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
