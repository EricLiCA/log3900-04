//
//  FriendsManagementViewController.swift
//  poly-paint-ios
//
//  Created by Tomato on 2018-10-11.
//  Copyright © 2018 PolyAcme. All rights reserved.
//

import UIKit

struct Headline {
    
}

class PendingFriendRequestTableViewCell: UITableViewCell {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var refuseButton: UIButton!
    
    
    @IBAction func acceptTapped(_ sender: UIButton) {
        self.desableButtons()
    }
    
    @IBAction func refuseTapped(_ sender: UIButton) {
        self.desableButtons()
    }
    
    func desableButtons() {
        acceptButton.isEnabled = false
        acceptButton.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        refuseButton.isEnabled = false
        refuseButton.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
    }
    
    func sendAcceptFriendshipNotification() {
        // Send notification to accept friendship
        let userInfo = [ "username" : usernameLabel.text! ]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "acceptFriendshipAlert"), object: nil, userInfo: userInfo)
    }
    
    func sendRefuseFriendshipNotification() {
        // Send notification to accept friendship
        let userInfo = [ "username" : usernameLabel.text! ]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refuseFriendshipAlert"), object: nil, userInfo: userInfo)
    }
    
}

class HeadlineTableViewCell: UITableViewCell {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var addAsFriendButton: UIButton!
    @IBOutlet weak var acceptButton: UIButton!
    
    @IBAction func addAsFriendTapped(_ sender: UIButton) {
        addAsFriendButton.isEnabled = false
        addAsFriendButton.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        self.sendUpdateUsernameNotification()
    }
    
    func sendUpdateUsernameNotification() {
        // Send notification to update username label in ProfileViewController
        let userInfo = [ "username" : usernameLabel.text! ]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "friendRequestAlert"), object: nil, userInfo: userInfo)
    }
}


class FriendsManagementViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var addUsersTableView: UITableView!
    
    var segueName: String = "";
    var users = [String]()
    var usersArray = [String]()
    var currentFriends = [String]()
    var pendingFriendships = [String]()
    var pendingFriendshipsArray = [String]()
    
    @IBOutlet weak var popoverTitleLabel: UILabel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        print(self.segueName)
        // Set as delegate for the message table
        self.addUsersTableView.delegate = self
        self.addUsersTableView.dataSource = self
        self.currentFriends = UserDefaults.standard.array(forKey: "friends") as! [String]
        
        
        if self.segueName == "toAddFriends" {
            self.setUpNotifications()
            popoverTitleLabel.text = "Send Friend Requests"
            self.getAllUsers()
        } else {
            self.pendingFriendships = ["Anna"]
            // so pending friend requests
            self.setupPendingFriendshipNotifications()
            popoverTitleLabel.text = "Pending Friend Requests"
            self.loadPendingFrienships()
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segueName == "toAddFriends" {
            return usersArray.count
        } else {
            return pendingFriendshipsArray.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if segueName == "toAddFriends" {
            // create a table cell
            let cell = addUsersTableView.dequeueReusableCell(withIdentifier: "AddFriendsCell", for: indexPath) as! HeadlineTableViewCell
            
            // Customize the cell
            let username = usersArray[indexPath.row]
            cell.usernameLabel?.text = username
            return cell
        } else {
            // create a table cell
            let cell = addUsersTableView.dequeueReusableCell(withIdentifier: "pendingFriendRequestCell", for: indexPath) as! PendingFriendRequestTableViewCell
            
            // Customize the cell
            let username = pendingFriendshipsArray[indexPath.row]
            cell.usernameLabel?.text = username
            return cell
        }
    }
    
    func addUserToAddFriendsTableView(username: String) {
        let newIndexPath = IndexPath(row: self.usersArray.count, section: 0)
        self.usersArray.append(username)
        self.addUsersTableView.insertRows(at: [newIndexPath], with: .automatic)
    }
    
    func showUsers() {
        for user in users {
            self.addUserToAddFriendsTableView(username: user)
        }
    }
    
    func addPendingFriendshipsToAddFriendsTableView(username: String) {
        let newIndexPath = IndexPath(row: self.usersArray.count, section: 0)
        self.pendingFriendshipsArray.append(username)
        self.addUsersTableView.insertRows(at: [newIndexPath], with: .automatic)
    }
    
    func showPendingFriendships() {
        for user in pendingFriendships {
            self.addPendingFriendshipsToAddFriendsTableView(username: user)
        }
    }
    
    func setUpNotifications() {
        // Observer for username update
        NotificationCenter.default.addObserver(self, selector: #selector(friendRequestAlert), name: NSNotification.Name(rawValue: "friendRequestAlert"), object: nil)
    }
    
    @objc func friendRequestAlert(_ notification: Notification) {
        let username = notification.userInfo!["username"]!
        self.sendFriendRequest(username: username as! String)
    }
    
    func setupPendingFriendshipNotifications() {
        // Observer for accept friendship
        NotificationCenter.default.addObserver(self, selector: #selector(acceptFriendshipAlert), name: NSNotification.Name(rawValue: "acceptFriendshipAlert"), object: nil)
        // Observer for refuse friendship
        NotificationCenter.default.addObserver(self, selector: #selector(refuseFriendshipAlert), name: NSNotification.Name(rawValue: "refuseFriendshipAlert"), object: nil)
    }
    
    @objc func acceptFriendshipAlert(_ notification: Notification) {
        let username = notification.userInfo!["username"]!
        print("accept frienship")
    }
    
    @objc func refuseFriendshipAlert(_ notification: Notification) {
        let username = notification.userInfo!["username"]!
        print("refuse frienship")
    }
    
    func sendFriendRequest(username: String) {
        print(username)
    }
    
    func getAllUsers() {
        let urlString = "http://localhost:3000/v2/users/"
        let url = URL(string: urlString)
        let session = URLSession.shared
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"

        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let task = session.dataTask(with: request) { data, response, error in
            let httpResponse = response as? HTTPURLResponse
            guard let data = data, error == nil else {
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: []) as! [Dictionary<String, String>]
            
            if (responseJSON as? [Dictionary<String, String>]) != nil {
                for user in responseJSON! {
                    if(user["id"] != UserDefaults.standard.string(forKey: "id") && !self.currentFriends.contains(user["id"]!)) {
                        self.users.append(user["username"] as! String)
                    }
                }
                DispatchQueue.main.async {
                    self.showUsers()
                }
            } else {
                DispatchQueue.main.async {
                    
                }
            }
        }
        
        task.resume()
    }
    
    func loadPendingFrienships() {
        //TODO
        showPendingFriendships()
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
