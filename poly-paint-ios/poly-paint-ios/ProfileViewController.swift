//
//  ProfileViewController.swift
//  poly-paint-ios
//
//  Created by Tomato on 2018-10-07.
//  Copyright © 2018 PolyAcme. All rights reserved.
//

import UIKit

class FriendTableViewCell: UITableViewCell {
    
    @IBOutlet weak var friendUsernameLabel: UILabel!
    @IBOutlet weak var removeAsFriendButton: UIButton!
    @IBOutlet weak var startChatButton: UIButton!
    @IBOutlet weak var friendGallery: UIButton!
    @IBOutlet weak var friendProfileImage: UIImageView!
    
    @IBAction func removeAsFriendTapped(_ sender: UIButton) {
        self.sendRemoveAsFriend()
    }

    @IBAction func startChatTapped(_ sender: UIButton) {
        self.startChat()
    }
    
    @IBAction func friendGalleryTapped(_ sender: UIButton) {
        self.goToFriendsGallery()
    }
    
    func sendRemoveAsFriend() {
        let userInfo = ["friendUsername": friendUsernameLabel.text!]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "removeAsFriendAlert"), object: nil, userInfo: userInfo)
    }
    
    func startChat() {
        let userInfo = ["friendUsername": friendUsernameLabel.text!]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "startChatAlert"), object: nil, userInfo: userInfo)
    }

    func goToFriendsGallery() {
        let userInfo = ["friendUsername": friendUsernameLabel.text!]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "goToFriendsGalleryAlert"), object: nil, userInfo: userInfo)
    }
}

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var friendsTableView: UITableView!
    @IBOutlet weak var pendingFriendRequestsButton: UIButton!
    @IBOutlet weak var notificationsLabel: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!

    var friends = [User]()
    var imagePicker = UIImagePickerController()
    
    @IBOutlet weak var chatButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        ChatModel.instance.notificationsSubject.asObservable().subscribe(onNext: {
            notifications in
            if notifications == 0 {
                self.chatButton.image = #imageLiteral(resourceName: "Chat")
            } else {
                self.chatButton.image = #imageLiteral(resourceName: "UnreadMessage")
            }
        })
        self.customizeUI()
        self.setUpNotifications()
        self.friendsTableView.delegate = self
        self.friendsTableView.dataSource = self
        self.imagePicker.delegate = self
        self.loadProfilePicture()
        self.getFriends()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // send segue identifier so FriendsManagement VC knows which popover to show
        if(segue.identifier == "toAddFriends" || segue.identifier == "toPendingFriendRequests") {
            let destinationViewController: FriendsManagementViewController  = segue.destination as! FriendsManagementViewController
            destinationViewController.segueName = segue.identifier!
        } else if (segue.identifier == "toFriendGallery") {
            let destinationViewController = segue.destination as! PublicImagesViewController
            let button = sender as! UIButton
            let index = button.tag
            let username = friends[index].username
            destinationViewController.search = username
            print(destinationViewController.search)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = friendsTableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as! FriendTableViewCell
        cell.friendUsernameLabel?.text = friends[indexPath.row].username
        let url: URL = URL(string: friends[indexPath.row].profilePictureUrl)!
        print("LOADING PROFILE: \(url)")
        let session = URLSession.shared
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            if data != nil {
                let image = UIImage(data: data!)
                if(image != nil) {
                    DispatchQueue.main.async(execute: {
                        cell.friendProfileImage.image = image
                    })
                }
            }
        })
        
        task.resume()
        cell.friendGallery.tag = indexPath.row
        return cell
    }
    
    func setUpNotifications() {
        // Observer for username update
        NotificationCenter.default.addObserver(self, selector: #selector(updateUsernameAlert), name: NSNotification.Name(rawValue: "updateUsernameAlert"), object: nil)
        // Observer for remove as friend
        NotificationCenter.default.addObserver(self, selector: #selector(removeAsFriendAlert), name: NSNotification.Name(rawValue: "removeAsFriendAlert"), object: nil)
        // Observer for go to friends gallery
        NotificationCenter.default.addObserver(self, selector: #selector(goToFriendsGalleryAlert), name: NSNotification.Name(rawValue: "goToFriendsGalleryAlert"), object: nil)
        // Observer for start chat with selected friend
        NotificationCenter.default.addObserver(self, selector: #selector(startChatAlert), name: NSNotification.Name(rawValue: "startChatAlert"), object: nil)
        // Observer for pending friendship (popover) accepted
        NotificationCenter.default.addObserver(self, selector: #selector(friendshipAcceptedAlert), name: NSNotification.Name(rawValue: "friendshipAcceptedAlert"), object: nil)
    }
    
    @objc func friendshipAcceptedAlert(_ notification: Notification) {
        let newFriend = User(id: notification.userInfo!["id"]! as! String, username: notification.userInfo!["username"] as! String, profilePictureUrl: notification.userInfo!["profilePictureUrl"]! as! String)
        self.addFriendsToFriendsTableView(friend: newFriend)
    }
    
    @objc func updateUsernameAlert(sender: AnyObject) {
        self.usernameLabel.text = UserDefaults.standard.string(forKey: "username")
    }
    
    @objc func removeAsFriendAlert(_ notification: Notification) {
        let friendUsername: String = notification.userInfo!["friendUsername"]! as! String
        // find friend id
        var friendNumberInArray = 0
        for friend in friends {
            if(friend.username == friendUsername) {
                self.deleteFriendship(friendId: friend.id, friendNumberInArray: friendNumberInArray)
            }
            friendNumberInArray = friendNumberInArray + 1
        }
    }
    
    // TODO: When API ready, go to friends public gallery
    @objc func goToFriendsGalleryAlert(_ notification: Notification) {
        let friendUsername: String = notification.userInfo!["friendUsername"]! as! String
    }
    
    // TODO: When API ready, start chat with friend
    @objc func startChatAlert(_ notification: Notification) {
        let friendUsername: String = notification.userInfo!["friendUsername"]! as! String
    }
    
    func getFriends() {
        let url = URL(string: SERVER.URL.rawValue + "v2/friendships/" + UserDefaults.standard.string(forKey: "id")!)
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
                    // fill friendd list
                    for friendship in responseJSON! {
                        let friend = User(id: friendship["id"]!, username: friendship["username"]!, profilePictureUrl: friendship["profileImage"]!)
                        self.addFriendsToFriendsTableView(friend: friend)
                    }
                }
            }
        }
        
        task.resume()
    }
    
    func addFriendsToFriendsTableView(friend: User) {
        let newIndexPath = IndexPath(row: self.friends.count, section: 0)
        self.friends.append(friend)
        self.friendsTableView.insertRows(at: [newIndexPath], with: .automatic)
    }
    
    func deleteFriendship(friendId: String, friendNumberInArray: Int) {
        let url = URL(string: SERVER.URL.rawValue + "v2/friendships/" + UserDefaults.standard.string(forKey: "id")!)
        let session = URLSession.shared
        var request = URLRequest(url: url!)
        request.httpMethod = "DELETE"
        
        // Setting data to send
        let paramToSend: [String: Any] = ["friendId": friendId, "token": UserDefaults.standard.string(forKey: "token")!]
        let jsonData = try? JSONSerialization.data(withJSONObject: paramToSend, options: .prettyPrinted)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        let task = session.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if (responseJSON as? [String: Any]) != nil {
                DispatchQueue.main.async {
                    self.friends.remove(at: friendNumberInArray)
                    self.friendsTableView.reloadData()
                }
            }
        }
        
        task.resume()
    }

    func customizeUI() {
        self.colorBorder()
        self.setUsernameLabel()
        self.friendsTableView.rowHeight = 150.0
    }
    
    func colorBorder() {
        self.profileView.layer.borderWidth = 1
        self.profileView.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    }
    
    func setUsernameLabel() {
        self.usernameLabel.text = UserDefaults.standard.string(forKey: "username")
    }
    
    func loadProfilePicture() {
        let url: URL = URL(string: UserDefaults.standard.string(forKey: "profileImage")!)!
        print("LOADING PROFILE: \(url)")
        let session = URLSession.shared
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            if data != nil {
                let image = UIImage(data: data!)
                if(image != nil) {
                    DispatchQueue.main.async(execute: {
                        self.profilePicture.image = image
                    })
                }
            }
        })
        
        task.resume()
    }
    
    @IBAction func changeProfilePictureTapped(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum;
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true, completion: nil)
        }
        self.changeProfilePicture(newURL: "https://s3.amazonaws.com/polypaintpro/profile-pictures/\(UserDefaults.standard.string(forKey: "username")!).jpeg")
        UserDefaults.standard.set("https://s3.amazonaws.com/polypaintpro/profile-pictures/\(UserDefaults.standard.string(forKey: "username")!).jpeg", forKey: "profileImage")
        URLCache.shared.removeAllCachedResponses()
    }
    
    func changeProfilePicture(newURL: String) {
        print("CHANGING PROFILE PICTURE WITH \(newURL)")
        let urlString = SERVER.URL.rawValue + "v2/users/" + UserDefaults.standard.string(forKey: "id")!
        let url = URL(string: urlString)
        let session = URLSession.shared
        var request = URLRequest(url: url!)
        request.httpMethod = "PUT"
        
        // Setting data to send
        let paramToSend: [String: Any] = ["profileImage": newURL as Any, "token": UserDefaults.standard.string(forKey: "token") as Any]
        let jsonData = try? JSONSerialization.data(withJSONObject: paramToSend, options: .prettyPrinted)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        let task = session.dataTask(with: request) { data, response, error in
            let httpResponse = response as? HTTPURLResponse
            guard let data = data, error == nil else {
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if (responseJSON as? [String: Any]) != nil {
                DispatchQueue.main.async {
                    UserDefaults.standard.set(newURL, forKey: "profileImage")
                    print("PROFILE IMAGE CHANGED TO: \(newURL)")
                }
            } else {
                print("Could not change profile image")
            }
        }
        
        task.resume()
        
        UserDefaults.standard.set("https://s3.amazonaws.com/polypaintpro/profile-pictures/\(UserDefaults.standard.string(forKey: "username")!)", forKey: "profileImage")
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.profilePicture.image = chosenImage
        S3Service.instance.upload(image: chosenImage)
        dismiss(animated: true, completion: nil)
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
