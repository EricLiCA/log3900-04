//
//  ProfileViewController.swift
//  poly-paint-ios
//
//  Created by Tomato on 2018-10-07.
//  Copyright © 2018 PolyAcme. All rights reserved.
//

import UIKit

struct FriendHeadline {
    
}

class FriendHeadlineTableViewCell: UITableViewCell {
    
    @IBOutlet weak var friendUsernameLabel: UILabel!
    @IBOutlet weak var removeAsFriendButton: UIButton!
    
    @IBAction func removeAsFriendTapped(_ sender: UIButton) {
        print("REMOVE FRIEND")
        removeAsFriendButton.isEnabled = false
        removeAsFriendButton.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.098/255, alpha: 0.22)
        self.sendRemoveAsFriend()
    }
    
    func sendRemoveAsFriend() {
        let userInfo = ["username": friendUsernameLabel.text!]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "removeAsFriendAlert"), object: nil, userInfo: userInfo)
    }
    
}

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var friendsTableView: UITableView!
    
    var friendsArray = [String]()
    var mockFriends = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUsernameLabel()
        self.colorBorder()
        self.setUpNotifications()
        self.mockFriends = ["John", "Becky", "Joe", "Paul"]
        // Set as delegate for the message table
        self.friendsTableView.delegate = self
        self.friendsTableView.dataSource = self
        self.getFriends()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Create a table cell
        //let cell = friendsTableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath)
        
        // Customize the cell
        //cell.textLabel?.text = friendsArray[indexPath.row]
        
        let cell = friendsTableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as! FriendHeadlineTableViewCell
        
        // Customize the cell
        cell.friendUsernameLabel?.text = friendsArray[indexPath.row]
        
        // Return the cell
        return cell
    }
    
    private func getFriends() {
        for friend in mockFriends {
            self.addFriendsToFriendsTableView(friendUsername: friend)
        }
    }
    
    private func addFriendsToFriendsTableView(friendUsername: String) {
        let newIndexPath = IndexPath(row: self.friendsArray.count, section: 0)
        self.friendsArray.append(friendUsername)
        self.friendsTableView.insertRows(at: [newIndexPath], with: .automatic)
        //self.friendsTableView.scrollToRow(at: newIndexPath, at: .bottom, animated: true)
    }
    
    func colorBorder() {
        self.profileView.layer.borderWidth = 1
        self.profileView.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    }
    
    func setUsernameLabel() {
        self.usernameLabel.text = UserDefaults.standard.string(forKey: "username")
    }
    
    func setUpNotifications() {
        // Observer for username update
        NotificationCenter.default.addObserver(self, selector: #selector(updateUsernameAlert), name: NSNotification.Name(rawValue: "updateUsernameAlert"), object: nil)
    }
    @objc func updateUsernameAlert(sender: AnyObject) {
        self.usernameLabel.text = UserDefaults.standard.string(forKey: "username")
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
