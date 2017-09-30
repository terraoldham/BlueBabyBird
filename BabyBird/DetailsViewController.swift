//
//  DetailsViewController.swift
//  BabyBird
//
//  Created by Terra Oldham on 9/29/17.
//  Copyright © 2017 HearsaySocial. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel!
    
    var tweet: Tweet!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        photoView.layer.cornerRadius = (photoView.frame.width / 2)
        photoView.layer.masksToBounds = true
        
        textLabel.text = tweet.text
        handleLabel.text = "@" + (tweet.user?.screenname)!
        nameLabel.text = tweet.user?.name
        timestampLabel.text = tweet.sinceTweet!
        photoView.setImageWith((tweet.user?.profileUrl)!)
        retweetCountLabel.text = tweet.retweetCount.description
        likeCountLabel.text = tweet.favoriteCount.description
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
