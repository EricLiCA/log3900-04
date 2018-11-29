//
//  PhotoCommentViewController.swift
//  poly-paint-ios
//
//  Created by Eric Sida Li on 2018-11-26.
//  Copyright © 2018 PolyAcme. All rights reserved.
//

import UIKit

class PhotoCommentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    @IBOutlet weak var commentField: UITextField!
    @IBOutlet weak var commentsTable: UITableView!
    var comments = [Comment]()
    var image: Image?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Create a table cell
        let cell = commentsTable.dequeueReusableCell(withIdentifier: "PhotoCommentCell", for: indexPath) as! PhotoCommentTableViewCell
        
        let comment = self.comments[indexPath.item]
        // Customize the cell
        cell.title.text = "\(comment.username) - \(comment.timestamp)"
        cell.comment.text = comment.comment
        
        // Return the cell
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.commentsTable.delegate = self
        self.commentsTable.dataSource = self
        self.commentField.delegate = self

        // Do any additional setup after loading the view.
        self.loadComments()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.addComment()
        self.commentField.text = ""
        return true
    }
    
    private func getImageCommentCreationUrl() -> String {
        return SERVER.URL.rawValue + "v2/imageComments/"
    }
    
    private func addComment() {
        guard let url = URL(string: getImageCommentCreationUrl()) else { return }
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Setting data to send
        let comment = self.commentField.text!
        let imageId = image!.id!
        let paramToSend: [String: Any] = ["imageId": imageId, "userId": UserDefaults.standard.string(forKey: "id")!, "comment": comment]
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
                    self.loadComments()
                }
            } else {
                DispatchQueue.main.async {
                    // TODO: Decide what we do in case of failure
                }
            }
        }
        
        task.resume()
    }
    
    private func getImageCommentURL() -> String {
        let imageId = self.image!.id!
        return SERVER.URL.rawValue + "v2/imageComments/\(imageId)"
    }
    
    func loadComments() {
        guard let url = URL(string: getImageCommentURL()) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if error != nil {
                print(error ?? "")
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                
                self.comments = [Comment]()
                
                for dictionary in json as! [[String: AnyObject]] {
                    let comment = dictionary["comment"] as! String
                    let username = dictionary["userName"] as! String
                    let timestamp = dictionary["timestamp"] as! String
                    self.comments.append(Comment(username: username, comment: comment, timestamp: timestamp))
                }
                
                DispatchQueue.main.async() {
                    self.commentsTable.reloadData()
                }
                
            } catch let jsonError {
                print(jsonError)
            }
            
            }.resume()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
