//
//  ComposeViewController.swift
//  BabyBird
//
//  Created by Terra Oldham on 9/29/17.
//  Copyright © 2017 HearsaySocial. All rights reserved.
//

import UIKit

@objc protocol ComposeViewControllerDelegate {
    @objc func composeViewController(composeViewController: ComposeViewController,
                                     tweet: Tweet)
}

class ComposeViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var tweetTextField: UITextView!
    @IBOutlet weak var characterCount: UILabel!
    
    var user = User.currentUser!
    var delegate: ComposeViewControllerDelegate?
    
    var handleToReply: String!
    var isReply: Bool! = false
    var replyId: IntMax!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoView.setImageWith((user.profileUrl)!)
        tweetTextField.delegate = self
        tweetTextField.becomeFirstResponder()
        
        if isReply {
            tweetTextField.text = ("@" + handleToReply + " ") as String!
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let tweetMax = 140
        let tweetCharCount = textView.text?.characters.count
        let charactersRemaining = tweetMax - tweetCharCount!
        characterCount.text = charactersRemaining.description
        if charactersRemaining < 20 {
            characterCount.textColor = UIColor.red
        } else {
            characterCount.textColor = UIColor.black
        }
    }
    
    @IBAction func onTweet(_ sender: Any) {
        if isReply == false {
            TwitterClient.sharedInstance?.publishTweet(tweetTextField.text!, success: { (tweet: Tweet) in
                self.dismiss(animated: true, completion: nil)
                self.delegate?.composeViewController(composeViewController: self, tweet: tweet)
                print("Tweet sent!")
            }, failure: { (error: Error) in
                print("error \(error.localizedDescription)")
            })
        } else {
            TwitterClient.sharedInstance?.publishResponseTweet(tweetTextField.text!, in_reply_to_status_id: replyId, success: { (tweet: Tweet) in
                print("Tweet sent!")
                self.dismiss(animated: true, completion: nil)
                self.delegate?.composeViewController(composeViewController: self, tweet: tweet)
                self.isReply = false
            }, failure: { (error: Error) in
                print("error \(error.localizedDescription)")
            })
        }
        
    }
    
    @IBAction func onCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

}
