//
//  PublicImageViewController.swift
//  poly-paint-ios
//
//  Created by JP Cech on 10/28/18.
//  Copyright © 2018 PolyAcme. All rights reserved.
//

import UIKit

class PublicImageViewController: UIViewController {
    
    var image: Image?
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageProtectionLevelLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateView()
    }
    
    func updateView () {
        imageView.image = image?.fullImage
        let defaultProtection = "public"
        imageProtectionLevelLabel.text = "Protection: \(image?.protectionLevel ?? defaultProtection)"
        self.navigationItem.title = image?.title
        self.updateLikes()
    }
    
    func updateLikes() {
        self.likesLabel.text = "Likes: \(image!.likes.count)"
        if (UserDefaults.standard.string(forKey: "id") == nil) {
            self.likeButton.isHidden = true
            return
        }
        
        let userId = UserDefaults.standard.string(forKey: "id")
        if (image!.likes.contains(userId!)) {
            likeButton.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            likeButton.setTitle("Unlike", for: .normal)
        } else {
            likeButton.backgroundColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
            likeButton.setTitle("Like", for: .normal)
        }
    }
    
    private func getLikeURL() -> String {
        return "http://localhost:3000/v2/imageLikes/"
    }
    
    @IBAction func likeAction(_ sender: Any) {
        if (likeButton.titleLabel?.text == "Like") {
            self.like()
        } else {
            self.unlike()
        }
    }
    
    private func like() {
        guard let url = URL(string: getLikeURL()) else { return }
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Setting data to send
        let imageId = image!.id!
        let paramToSend: [String: Any] = ["imageId": imageId, "userId": UserDefaults.standard.string(forKey: "id")!]
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
                    self.image?.likes.insert(UserDefaults.standard.string(forKey: "id")!)
                    self.updateLikes()
                }
            } else {
                DispatchQueue.main.async {
                    // TODO: Decide what we do in case of failure
                }
            }
        }
        
        task.resume()
    }
    
    private func getUnlikeURL() -> String {
        let imageId = image!.id!
        let userId = UserDefaults.standard.string(forKey: "id")!
        return "\(self.getLikeURL())\(imageId)/\(userId)"
    }
    
    private func unlike() {
        guard let url = URL(string: getUnlikeURL()) else { return }
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        let task = session.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                DispatchQueue.main.async {
                    self.image?.likes.remove(UserDefaults.standard.string(forKey: "id")!)
                    self.updateLikes()
                }
            } else {
                DispatchQueue.main.async {
                    // TODO: Decide what we do in case of failure
                }
            }
        }
        
        task.resume()
    }
}
