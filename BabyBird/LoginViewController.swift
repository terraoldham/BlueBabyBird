//
//  LoginViewController.swift
//  BabyBird
//
//  Created by Terra Oldham on 9/25/17.
//  Copyright © 2017 HearsaySocial. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLoginButton(_ sender: Any) {
        var token = ""
        let twitterClient = BDBOAuth1SessionManager(baseURL: URL(string: "https://api.twitter.com"), consumerKey: "xdn221RrVQHYhd4uw96iKQp12", consumerSecret: "r9zAJ8PFKamr3wANygXowpwi8MpAu1PrOz17dng5z7d3eEiYyw")
        
        twitterClient?.deauthorize()
        twitterClient?.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string: "bluebabybird://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            print("I got a token!")
            
            token = requestToken.token
            let url = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=" + token)
            UIApplication.shared.open(url!)
            
        }, failure: { (error: Error!) -> Void in
            print("error : \(error.localizedDescription)")
        })
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
