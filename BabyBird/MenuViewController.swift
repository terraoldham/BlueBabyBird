//
//  MenuViewController.swift
//  BabyBird
//
//  Created by Terra Oldham on 10/4/17.
//  Copyright © 2017 HearsaySocial. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    private var homeTimelineViewController: UIViewController!
    private var profileViewController: UIViewController!
    private var mentionsViewController: UIViewController!
    private var accountsViewController: UIViewController!
    
    var viewControllers: [UIViewController] = []
    
    var hamburgerViewController: HamburgerViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        homeTimelineViewController = storyboard.instantiateViewController(withIdentifier: "TweetsNavigationController")
        profileViewController = storyboard.instantiateViewController(withIdentifier: "ProfileNavigationController")
        mentionsViewController = storyboard.instantiateViewController(withIdentifier: "MentionsNavigationController")
        accountsViewController = storyboard.instantiateViewController(withIdentifier: "AccountsViewController")
        let menuViewController = storyboard.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        
        viewControllers.append(homeTimelineViewController)
        viewControllers.append(profileViewController)
        viewControllers.append(mentionsViewController)
        viewControllers.append(accountsViewController)
        
        menuViewController.hamburgerViewController = hamburgerViewController
        hamburgerViewController.contentViewController = homeTimelineViewController
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell
        cell.contentView.backgroundColor = UIColor(red: 0, green: 172/255, blue: 237/255, alpha: 1.0)
        let titles = ["Home", "Profile", "Mentions", "Accounts"]
        cell.menuTitleLabel.text = titles[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        hamburgerViewController.contentViewController = viewControllers[indexPath.row]
    }
}
