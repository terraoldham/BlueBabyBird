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
    @IBOutlet weak var loginButton: UIButton!
    
     var window: UIWindow?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.layer.cornerRadius = 5
        loginButton.clipsToBounds = true
        
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLoginButton(_ sender: Any) {
        TwitterClient.sharedInstance?.login(success: { () -> () in
            print("Successfully logged in!")
            self.performSegue(withIdentifier: "loginSegue", sender: nil)
        }) { (error: Error) -> () in
            print("Error: \(error.localizedDescription)")
        }
        
    }

}
