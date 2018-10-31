//
//  ProtectedImagePasswordViewController.swift
//  poly-paint-ios
//
//  Created by JP Cech on 10/30/18.
//  Copyright © 2018 PolyAcme. All rights reserved.
//

import UIKit

class ProtectedImagePasswordViewController: UIViewController {
    var image: Image?
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var confirmNewPasswordTextField: UITextField!
    @IBOutlet weak var passwordsDontMatchLabel: UILabel!
    @IBOutlet weak var passwordChangedLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var changePassBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideLabels()
        if (image?.protectionLevel == "protected") {
            self.titleLabel.text = "Change " + (image?.title)! + " Password"
            self.changePassBtn.setTitle("Change password", for: [])
        }
        else {
            self.titleLabel.text = "Set " + (image?.title)! + " Password"
            self.changePassBtn.setTitle("Set Password", for: [])
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func changePasswordTapped(_ sender: UIButton) {
        let password = newPasswordTextField.text
        let confirmPassword = confirmNewPasswordTextField.text
        
        if password != "" && password == confirmPassword {
            self.changePassword(password: password!)
        } else if password != confirmPassword {
            self.passwordsDontMatchLabel.isHidden = false
        }
    }
    
    func changePassword(password: String) {
        print("ello")
        let urlString = "http://localhost:3000/v2/images/" + (image?.id)!
        let url = URL(string: urlString)
        let session = URLSession.shared
        var request = URLRequest(url: url!)
        request.httpMethod = "PUT"
        let imageToSend: [String: Any] = [
            "ownerId": (image?.ownerId)!,
            "title" :(image?.title)!,
            "protectionLevel": "protected",
            "password": newPasswordTextField.text!,
            "thumbnailUrl": "", // leave empty until thumbnails are supported. Would cause a nil crash while unwrapping otherwise
            "fullImageUrl": (image?.fullImageUrl)!,
            ]
        let jsonData = try? JSONSerialization.data(withJSONObject: imageToSend, options: .prettyPrinted)
    let jsonString = String(data: jsonData!, encoding: .utf8)
        print(jsonString!)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        let task = session.dataTask(with: request) { data, response, error in
            _ = response as? HTTPURLResponse
            guard let data = data, error == nil else {
                print("here")
                return
            }
            
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            print(responseJSON!)
            if (responseJSON as? [String: Any]) != nil {
                print(responseJSON)
                DispatchQueue.main.async {
                    self.changePasswordDone()
                }
            }
        }
        
        task.resume()
    }
    
    func changePasswordDone() {
        self.resetPasswordLabelAndTextFields()
        self.showPasswordChangedLabel()
    }
    
    func showPasswordChangedLabel() {
        self.passwordChangedLabel.isHidden = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            self.passwordChangedLabel.isHidden = true
            self.passwordChangedLabel.alpha = 1
        })
    }
    
    func hideLabels(){
        
        self.passwordsDontMatchLabel.isHidden = true
        self.passwordChangedLabel.isHidden = true
    }
    
    func resetPasswordLabelAndTextFields() {
        self.passwordsDontMatchLabel.isHidden = true
        self.newPasswordTextField.text = ""
        self.confirmNewPasswordTextField.text = ""
    }
    
}
