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
    @IBOutlet weak var startChatButton: UIButton!
    @IBOutlet weak var friendGallery: UIButton!
    
    @IBAction func removeAsFriendTapped(_ sender: UIButton) {
        removeAsFriendButton.isEnabled = false
        removeAsFriendButton.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        self.sendRemoveAsFriend()
    }
    
    func sendRemoveAsFriend() {
        let userInfo = ["friendUsername": friendUsernameLabel.text!]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "removeAsFriendAlert"), object: nil, userInfo: userInfo)
    }
    
    // TODO: determine what this functionnality does
    @IBAction func startChatTapped(_ sender: UIButton) {
        self.startChat()
    }
    
    // TODO: determine what this functionnality does
    func startChat() {
        // TODO: determine what this functionnality does
        let userInfo = ["friendUsername": friendUsernameLabel.text!]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "startChatAlert"), object: nil, userInfo: userInfo)
    }

    // TODO: When API ready, go to friends public gallery
    @IBAction func friendGalleryTapped(_ sender: UIButton) {
        // TODO: When API ready, go to friends public gallery
        self.goToFriendsGallery()
    }
    
    func goToFriendsGallery() {
        let userInfo = ["friendUsername": friendUsernameLabel.text!]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "goToFriendsGalleryAlert"), object: nil, userInfo: userInfo)
    }
}

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var friendsTableView: UITableView!
    @IBOutlet weak var pendingFriendRequestsButton: UIButton!
    
    var friendsArray = [String]()
    var friends = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.friendsTableView.rowHeight = 150.0
        self.setUsernameLabel()
        self.colorBorder()
        self.setUpNotifications()
        self.friends = []
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
        let cell = friendsTableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as! FriendHeadlineTableViewCell
        // Customize the cell
        cell.friendUsernameLabel?.text = friendsArray[indexPath.row]
        // Return the cell
        return cell
    }
    
    private func getFriends() {
        let url = URL(string: "http://localhost:3000/v2/friendships/" + UserDefaults.standard.string(forKey: "id")!)
        let session = URLSession.shared
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = session.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: []) as! [Dictionary<String,String>]
            if (responseJSON) != nil {
                DispatchQueue.main.async {
                    // fill friend list
                    for friendship in responseJSON! {
                        self.friends.append(friendship["FriendId"]!)
                    self.addFriendsToFriendsTableView(friendUsername: friendship["FriendId"]!)
                    }
                    UserDefaults.standard.set(self.friends, forKey: "friends")
                }
            }
        }
        
        task.resume()
    }
    
    private func addFriendsToFriendsTableView(friendUsername: String) {
        let newIndexPath = IndexPath(row: self.friendsArray.count, section: 0)
        self.friendsArray.append(friendUsername)
        self.friendsTableView.insertRows(at: [newIndexPath], with: .automatic)
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
        // Observer for remove as friend
        NotificationCenter.default.addObserver(self, selector: #selector(removeAsFriendAlert), name: NSNotification.Name(rawValue: "removeAsFriendAlert"), object: nil)
        // Observer for go to friends gallery
        NotificationCenter.default.addObserver(self, selector: #selector(goToFriendsGalleryAlert), name: NSNotification.Name(rawValue: "goToFriendsGalleryAlert"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(startChatAlert), name: NSNotification.Name(rawValue: "startChatAlert"), object: nil)
        
    }
    
    @objc func updateUsernameAlert(sender: AnyObject) {
        self.usernameLabel.text = UserDefaults.standard.string(forKey: "username")
    }
    
    // TODO: When API ready, remove from friends list and update interface
    @objc func removeAsFriendAlert(_ notification: Notification) {
        // TODO: call api to remove friend
        let friendUsername: String = notification.userInfo!["friendUsername"]! as! String
        self.removeFriendship(friendId: friendUsername)
        // TODO: refresh friends list
    }
    
    // TODO: When API ready, go to friends public gallery
    @objc func goToFriendsGalleryAlert(_ notification: Notification) {
        // TODO: call api to go to friends gallery
        let friendUsername: String = notification.userInfo!["friendUsername"]! as! String
    }
    
    // TODO: When API ready, start chat with friend
    @objc func startChatAlert(_ notification: Notification) {
        // TODO: call api to start chat with friend
        let friendUsername: String = notification.userInfo!["friendUsername"]! as! String
    }
    
    func removeFriendship(friendId: String) {
        let url = URL(string: "http://localhost:3000/v2/friendships/" + UserDefaults.standard.string(forKey: "id")!)
        let session = URLSession.shared
        var request = URLRequest(url: url!)
        request.httpMethod = "DELETE"
        
        // Setting data to send
        let paramToSend: [String: Any] = ["friendId": friendId, "token": UserDefaults.standard.string(forKey: "token")!]
        print("PARAMS")
        print(paramToSend)
        let jsonData = try? JSONSerialization.data(withJSONObject: paramToSend, options: .prettyPrinted)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        let task = session.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            print(responseJSON)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // send segue identifier so FriendsManagement VC knows which popover to show
        if(segue.identifier != "toAccountSettings") {
            let destinationViewController: FriendsManagementViewController  = segue.destination as! FriendsManagementViewController
            destinationViewController.segueName = segue.identifier!
        }
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
