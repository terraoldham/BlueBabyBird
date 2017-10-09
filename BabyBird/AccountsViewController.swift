//
//  AccountsViewController.swift
//  BabyBird
//
//  Created by Terra Oldham on 10/8/17.
//  Copyright © 2017 HearsaySocial. All rights reserved.
//

import UIKit

class AccountsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addView: UIImageView!
    
    var accounts: [User]! = [User.currentUser!]

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        
        let addTap = UITapGestureRecognizer(target: self, action: #selector(onAddTap(tapGestureRecognizer:)))
        addView.isUserInteractionEnabled = true
        addView.addGestureRecognizer(addTap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accounts.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(accounts)
        let cell = tableView.dequeueReusableCell(withIdentifier: "AccountCell", for: indexPath) as! AccountCell
        cell.contentView.backgroundColor = UIColor(red: 0, green: 172/255, blue: 237/255, alpha: 1.0)
        cell.account = accounts![indexPath.row]
        print(accounts![indexPath.row])
        return cell
    }
    
    @objc func onAddTap(tapGestureRecognizer:
        UITapGestureRecognizer) {
        TwitterClient.sharedInstance?.logout()
        TwitterClient.sharedInstance?.login(success: { () -> () in
            
        }) { (error: Error) -> () in
            print("Error: \(error.localizedDescription)")
        }
    }
    

}
