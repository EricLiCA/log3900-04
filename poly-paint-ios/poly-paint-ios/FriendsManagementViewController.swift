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
    
    @IBAction func addAssFriendTapped(_ sender: UIButton) {
        print("ADD user: " + usernameLabel.text!)
        addAsFriendButton.isEnabled = false
        addAsFriendButton.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.098/255, alpha: 0.22)
    
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
        
        self.showUsers()
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
