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

class HeadlineTableViewCell: UITableViewCell {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var addAsFriendButton: UIButton!
    
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
    
    var mockUsers = [String]()
    var usersArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mockUsers = ["John", "Betty", "Bob", "Bobette", "Emy", "Emma", "Paul", "Bobo", "Hello", "Evil", "Evil666"]
        // Set as delegate for the message table
        self.addUsersTableView.delegate = self
        self.addUsersTableView.dataSource = self
        self.setUpNotifications()
        self.showUsers()
        self.getAllUsers()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // create a table cell
        let cell = addUsersTableView.dequeueReusableCell(withIdentifier: "AddFriendsCell", for: indexPath) as! HeadlineTableViewCell
        
        // Customize the cell
        let username = usersArray[indexPath.row]
        cell.usernameLabel?.text = username
        //cell.textLabel?.text = usersArray[indexPath.row]
        
        // Return the cell
        return cell
    }
    
    func addUserToAddFriendsTableView(username: String) {
        let newIndexPath = IndexPath(row: self.usersArray.count, section: 0)
        self.usersArray.append(username)
        self.addUsersTableView.insertRows(at: [newIndexPath], with: .automatic)
        //self.addUsersTableView.scrollToRow(at: newIndexPath, at: .bottom, animated: true)
    }
    
    func showUsers() {
        for user in mockUsers {
            self.addUserToAddFriendsTableView(username: user)
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
    
    func sendFriendRequest(username: String) {
        print(username)
    }
    
    func getAllUsers() {
        let urlString = "http://localhost:3000/v1/users/"
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
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            print(responseJSON)
            if (responseJSON as? [String: Any]) != nil {
                DispatchQueue.main.async {
                    
                }
            } else {
                DispatchQueue.main.async {
                    
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
