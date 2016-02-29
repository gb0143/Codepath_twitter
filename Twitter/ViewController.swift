//
//  ViewController.swift
//  Twitter
//
//  Created by Gaurang Bhatt on 2/8/16.
//  Copyright © 2016 Gaurang Bhatt. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onLogin(sender: AnyObject) {
        
        //have to create the loginWithCompletion method in TwitterClient
        TwitterClient.sharedInstance.loginWithCompletion(){
            (user: User?, error: NSError?) in
            if user != nil{
                //perform seque, so that instead of going back to the 
                //login page, we go to the timeline page
                self.performSegueWithIdentifier("loginSegue", sender: self)
            }else {
                // handle login error
            }
        }
     
    }

}

