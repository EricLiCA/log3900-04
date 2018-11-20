//
//  CreateNewImageViewController.swift
//  poly-paint-ios
//
//  Created by JP Cech on 11/19/18.
//  Copyright © 2018 PolyAcme. All rights reserved.
//

import UIKit

class CreateNewImageViewController: UIViewController {
    
    
    @IBOutlet weak var imageTitle: UITextField!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var passwordStack: UIStackView!
    @IBOutlet weak var passMatch: UILabel!
    @IBOutlet weak var setPasswordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    
    var selectedProtectionLevel: String = "public"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.passwordStack.isHidden = true;
        self.passMatch.isHidden = true;
        self.confirmPasswordField.widthAnchor.constraint(equalToConstant: 80).isActive = true
        self.setPasswordField.widthAnchor.constraint(equalToConstant: 80).isActive = true
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onTapProtection(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            self.passwordStack.isHidden = true
            self.selectedProtectionLevel = "public"
            break
        case 1:
            self.passwordStack.isHidden = true
             self.selectedProtectionLevel = "private"
            break
        case 2:
            self.passwordStack.isHidden = false
            self.selectedProtectionLevel = "protected"
        default:
            break
        }
    }
    
    @IBAction func okTapped(_ sender: Any) {
        let password = self.setPasswordField.text!
        let confirmPassword = self.confirmPasswordField.text!
        
        if ((self.selectedProtectionLevel == "protected" && password != "" && password == confirmPassword) || self.selectedProtectionLevel != "protected" ) {
            let urlString = "http://localhost:3000/v2/images"
            let url = URL(string: urlString)
            let session = URLSession.shared
            var request = URLRequest(url: url!)
            request.httpMethod = "POST"
            
            let imageToSend: [String: Any] = [
                "ownerId": UserDefaults.standard.string(forKey: "id")!,
                "title" :self.imageTitle.text!,
                "protectionLevel": self.selectedProtectionLevel,
                "password": self.selectedProtectionLevel == "protected" ? self.setPasswordField.text! : "",
                "thumbnailUrl": "",
                "fullImageUrl": "https://picsum.photos/300/400/?random",
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
                if let responseJSON = responseJSON as? [String: Any] {
                    DispatchQueue.main.async {
                        let image = Image()
                        image.id = responseJSON ["id"] as? String
                        image.ownerId = responseJSON ["ownerId"] as? String
                        image.title = responseJSON ["title"] as? String
                        image.protectionLevel = responseJSON ["protectionLevel"] as? String
                        image.password = responseJSON ["password"] as? String
                        image.thumbnailUrl = responseJSON ["thumbnailUrl"] as? String
                        image.fullImageUrl = responseJSON ["fullImageUrl"] as? String
                        print(image.id!)
                        print(image.ownerId!)
                        print(image.title!)
                        print(image.protectionLevel!)
                        print(image.password!)
                        print(image.thumbnailUrl!)
                        print(image.fullImageUrl!)
                    }
                }
            }
            task.resume()
        } else if password != confirmPassword {
            self.passMatch.isHidden = false
        }
    }
}
