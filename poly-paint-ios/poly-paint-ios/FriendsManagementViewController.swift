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
        self.disableButtons()
        self.sendAcceptFriendshipNotification()
    }
    
    @IBAction func refuseTapped(_ sender: UIButton) {
        self.disableButtons()
        self.sendAcceptFriendshipNotification()
    }
    
    func disableButtons() {
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

class UsersNotInFriendsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var addAsFriendButton: UIButton!
    @IBOutlet weak var acceptButton: UIButton!
    
    @IBAction func addAsFriendTapped(_ sender: UIButton) {
        self.disableButton()
        self.sendUpdateUsernameNotification()
    }
    
    func sendUpdateUsernameNotification() {
        // Send notification to update username label in ProfileViewController
        let userInfo = [ "username" : usernameLabel.text! ]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "friendRequestAlert"), object: nil, userInfo: userInfo)
    }
    
    func disableButton() {
        addAsFriendButton.isEnabled = false
        addAsFriendButton.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
    }
    
}

class FriendsManagementViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var friendManagementTableView: UITableView!
    @IBOutlet weak var popoverTitleLabel: UILabel!
    
    var segueName: String = "";
    var usersNotInFriendsCells = [User]()
    var usersNotInFriends = [User]()
    var pendingFriendships = [User]()
    var pendingFriendshipsCells = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set as delegate for the message table
        self.friendManagementTableView.delegate = self
        self.friendManagementTableView.dataSource = self
        self.actionsForSegue()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func actionsForSegue() {
        if self.segueName == "toAddFriends" {
            //self.currentFriends = UserDefaults.standard.array(forKey: "friends") as! [String]
            self.setupAddFriendsNotifications()
            popoverTitleLabel.text = "Send Friend Requests"
            //self.getAllUsers()
            self.loadUsersNotInFriends()
        } else {
            //self.pendingFriendships = ["Anna"]
            self.setupPendingFriendshipNotifications()
            popoverTitleLabel.text = "Pending Friend Requests"
            self.loadPendingFrienships()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segueName == "toAddFriends" {
            return usersNotInFriendsCells.count
        } else {
            return pendingFriendshipsCells.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if segueName == "toAddFriends" {
            // create a table cell
            let cell = friendManagementTableView.dequeueReusableCell(withIdentifier: "AddFriendsCell", for: indexPath) as! UsersNotInFriendsTableViewCell
            // Customize the cell
            let username = usersNotInFriendsCells[indexPath.row].username
            cell.usernameLabel?.text = username
            return cell
        } else {
            // create a table cell
            let cell = friendManagementTableView.dequeueReusableCell(withIdentifier: "pendingFriendRequestCell", for: indexPath) as! PendingFriendRequestTableViewCell
            // Customize the cell
            let username = pendingFriendshipsCells[indexPath.row].username
            cell.usernameLabel?.text = username
            return cell
        }
    }
    
    func addUserToAddFriendsTableView(user: User) {
        let newIndexPath = IndexPath(row: self.usersNotInFriendsCells.count, section: 0)
        self.usersNotInFriendsCells.append(user)
        self.friendManagementTableView.insertRows(at: [newIndexPath], with: .automatic)
    }
    
    func showUsers() {
        for user in usersNotInFriends {
            self.addUserToAddFriendsTableView(user: user)
        }
    }
    
    func addPendingFriendshipsToAddFriendsTableView(user: User) {
        let newIndexPath = IndexPath(row: self.usersNotInFriendsCells.count, section: 0)
        self.pendingFriendshipsCells.append(user)
        self.friendManagementTableView.insertRows(at: [newIndexPath], with: .automatic)
    }
    
    func showPendingFriendships() {
        for user in pendingFriendships {
            self.addPendingFriendshipsToAddFriendsTableView(user: user)
        }
    }
    
    func setupAddFriendsNotifications() {
        // Observer for username update
        NotificationCenter.default.addObserver(self, selector: #selector(friendRequestAlert), name: NSNotification.Name(rawValue: "friendRequestAlert"), object: nil)
    }
    
    @objc func friendRequestAlert(_ notification: Notification) {
        let username: String = notification.userInfo!["username"]! as! String
        // GET USER OBJECT
        for user in usersNotInFriends {
            if user.username == username {
                self.sendFriendRequest(user: user)
            }
        }
        
        
    }
    
    func setupPendingFriendshipNotifications() {
        // Observer for accept friendship
        NotificationCenter.default.addObserver(self, selector: #selector(acceptFriendshipAlert), name: NSNotification.Name(rawValue: "acceptFriendshipAlert"), object: nil)
        // Observer for refuse friendship
        NotificationCenter.default.addObserver(self, selector: #selector(refuseFriendshipAlert), name: NSNotification.Name(rawValue: "refuseFriendshipAlert"), object: nil)
    }
    
    @objc func acceptFriendshipAlert(_ notification: Notification) {
        let username: String = notification.userInfo!["username"]! as! String
        
        for user in pendingFriendships {
            if user.username == username {
                self.sendAcceptFriendship(userId: user.id)
                // add friends to friend list NOTIFICATION
                let userInfo = ["id": user.id, "username": user.username, "profilePictureUrl": user.profilePictureUrl]
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "friendshipAcceptedAlert"), object: nil, userInfo: userInfo)
            }
        }
        
        
    }
    
    @objc func refuseFriendshipAlert(_ notification: Notification) {
        let username: String = notification.userInfo!["username"]! as! String
        
        for user in pendingFriendships {
            if user.username == username {
                self.sendRefuseFriendship(userId: user.id)
                // add friends to friend list NOTIFICATION
            }
        }
        //get user object
        
    }
    
    // TODO: When API ready, send friend request
    func sendFriendRequest(user: User) {
        
        let url = URL(string: "http://localhost:3000/v2/friendships/" + UserDefaults.standard.string(forKey: "id")!)
        let session = URLSession.shared
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        
        // Setting data to send
        let paramToSend: [String: Any] = ["friendId": user.id, "token": UserDefaults.standard.string(forKey: "token")!]
        let jsonData = try? JSONSerialization.data(withJSONObject: paramToSend, options: .prettyPrinted)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        let task = session.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                print(responseJSON)
                DispatchQueue.main.async {
                    
                }
            } else {
                DispatchQueue.main.async {
                    
                }
            }
        }
        
        task.resume()
        
        
        
    }
    
    // TODO: When API ready, accept friendship
    func sendAcceptFriendship(userId: String) {
        let url = URL(string: "http://localhost:3000/v2/friendships/" + UserDefaults.standard.string(forKey: "id")!)
        let session = URLSession.shared
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        
        // Setting data to send
        let paramToSend: [String: Any] = ["friendId": userId, "token": UserDefaults.standard.string(forKey: "token")!]
        let jsonData = try? JSONSerialization.data(withJSONObject: paramToSend, options: .prettyPrinted)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        let task = session.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                print("response ACCEPT friendship")
                print(responseJSON)
                DispatchQueue.main.async {
                }
            } else {
                DispatchQueue.main.async {
                    
                }
            }
        }
        
        task.resume()
    }
    
    // TODO: When API ready, refuse friendship
    func sendRefuseFriendship(userId: String) {
        let url = URL(string: "http://localhost:3000/v2/friendships/" + UserDefaults.standard.string(forKey: "id")!)
        let session = URLSession.shared
        var request = URLRequest(url: url!)
        request.httpMethod = "DELETE"
        
        // Setting data to send
        let paramToSend: [String: Any] = ["friendId": userId, "token": UserDefaults.standard.string(forKey: "token")!]
        let jsonData = try? JSONSerialization.data(withJSONObject: paramToSend, options: .prettyPrinted)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        let task = session.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                DispatchQueue.main.async {
                }
            } else {
                DispatchQueue.main.async {
                    
                }
            }
        }
        
        task.resume()
    }
    
    // TODO: When API ready, get pending friendships
    func loadPendingFrienships() {
        //showPendingFriendships()
        print("CALLING LOAD PENDING ")
        let urlString = "http://localhost:3000/v2/friendships/" + UserDefaults.standard.string(forKey: "id")! + "?pending=true"
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
                    let pendingFriend = User(id: user["id"]!, username: user["username"]!, profilePictureUrl: user["profileImage"]!)
                    self.pendingFriendships.append(pendingFriend)
                }
                DispatchQueue.main.async {
                    self.showPendingFriendships()
                }
            }
        }
        
        task.resume()
    }
    
    func loadUsersNotInFriends() {
        // usersExceptFriends
        let urlString = "http://localhost:3000/v2/usersExceptFriends/" + UserDefaults.standard.string(forKey: "id")!
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
                    let userNotFriend = User(id: user["id"]!, username: user["username"]!, profilePictureUrl: user["profileImage"]!)
                    self.usersNotInFriends.append(userNotFriend)
                }
                DispatchQueue.main.async {
                    self.showUsers()
                }
            }
        }
        
        task.resume()
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
