//
//  PrivateImageViewController.swift
//  poly-paint-ios
//
//  Created by JP Cech on 10/28/18.
//  Copyright © 2018 PolyAcme. All rights reserved.
//

import UIKit

class PrivateImageViewController: UIViewController, ChangeImagePasswordProtocol {
    var image: Image?
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageProtectionLevelLabel: UILabel!
    @IBOutlet weak var editBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image?.fullImage
        imageProtectionLevelLabel.text = image?.protectionLevel
        self.navigationItem.title = image?.title
    }
    
    @IBAction func editImage(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let openEditorAction = UIAlertAction(title: "Open In Editor", style: .default, handler: { (alert: UIAlertAction!) -> Void in
            self.performSegue(withIdentifier: "toImageEditorFromPrivate", sender: self)
        })
        alertController.addAction(openEditorAction)
        
        if image?.protectionLevel != "public" {
            let makePublicAction = UIAlertAction(title: "Set As Public", style: .default, handler: { (alert: UIAlertAction!) -> Void in
                self.setImageAsPublic()
            })
            alertController.addAction(makePublicAction)
        }
        
        if image?.protectionLevel != "private" {
            let makePrivateAction = UIAlertAction(title: "Set As Private", style: .default, handler: { (alert: UIAlertAction!) -> Void in
                self.setImageAsPrivate()
            })
            alertController.addAction(makePrivateAction)
        }
        
        if image?.protectionLevel != "protected" {
            let makeProtectedAction = UIAlertAction(title: "Set As Protected", style: .default, handler: { (alert: UIAlertAction!) -> Void in
                self.performSegue(withIdentifier: "toChangeImagePassword", sender: self)
            })
            alertController.addAction(makeProtectedAction)
        }
        
        if image?.protectionLevel == "protected" {
            let changePasswordAction = UIAlertAction(title: "Change Password", style: .default, handler: { (alert: UIAlertAction!) -> Void in
                self.performSegue(withIdentifier: "toChangeImagePassword", sender: self)
            })
            alertController.addAction(changePasswordAction)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: { (alert: UIAlertAction!) -> Void in
        })
        alertController.addAction(cancelAction)
        
        
        
        if let popoverController = alertController.popoverPresentationController {
            popoverController.barButtonItem = sender
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toChangeImagePassword" {
            let ProtectedImagePasswordVC = segue.destination as! ProtectedImagePasswordViewController
            ProtectedImagePasswordVC.image = self.image
            ProtectedImagePasswordVC.changeImagePasswordProtocol = self
        }
        if segue.identifier == "toImageEditorFromPrivate" {
            let ImageEditorVC = segue.destination as! DrawViewController
            ImageEditorVC.image = self.image
        }
    }
    
    func setImageAsPublic() {
        let urlString = "http://localhost:3000/v2/images/" + (image?.id)!
        let url = URL(string: urlString)
        let session = URLSession.shared
        var request = URLRequest(url: url!)
        request.httpMethod = "PUT"
        
        let imageToSend: [String: Any] = [
            "ownerId": (image?.ownerId)!,
            "title" :(image?.title)!,
            "protectionLevel": "public",
            "password": "",
            "thumbnailUrl": "", // leave empty until thumbnails are supported. Would cause a nil crash while unwrapping otherwise
            "fullImageUrl": (image?.fullImageUrl)!,
            ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: imageToSend, options: .prettyPrinted)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        let task = session.dataTask(with: request) { data, response, error in
            _ = response as? HTTPURLResponse
            guard let data = data, error == nil else {
                return
            }
            
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if (responseJSON as? [String: Any]) != nil {
                DispatchQueue.main.async {
                    self.image?.protectionLevel = "public"
                    self.image?.password = ""
                    self.imageProtectionLevelLabel.text = self.image?.protectionLevel
                }
            }
        }
        
        task.resume()
    }
    
    func setImageAsPrivate() {
        let urlString = SERVER.URL.rawValue + "v2/images/" + (image?.id)!
        let url = URL(string: urlString)
        let session = URLSession.shared
        var request = URLRequest(url: url!)
        request.httpMethod = "PUT"
        
        let imageToSend: [String: Any] = [
            "ownerId": (image?.ownerId)!,
            "title" :(image?.title)!,
            "protectionLevel": "private",
            "password": "",
            "thumbnailUrl": "", // leave empty until thumbnails are supported
            "fullImageUrl": (image?.fullImageUrl)!,
            ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: imageToSend, options: .prettyPrinted)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        let task = session.dataTask(with: request) { data, response, error in
            _ = response as? HTTPURLResponse
            guard let data = data, error == nil else {
                return
            }
            
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if (responseJSON as? [String: Any]) != nil {
                DispatchQueue.main.async {
                    self.image?.protectionLevel = "private"
                    self.image?.password = ""
                    self.imageProtectionLevelLabel.text = self.image?.protectionLevel
                }
            }
        }
        
        task.resume()
    }
    
    func setNewImage (image: Image?){
        self.image = image
        self.imageProtectionLevelLabel.text = image?.protectionLevel!
        
    }
}
