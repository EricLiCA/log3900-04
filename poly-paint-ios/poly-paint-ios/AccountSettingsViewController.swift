//
//  AccountSettingsViewController.swift
//  poly-paint-ios
//
//  Created by Tomato on 2018-10-09.
//  Copyright © 2018 PolyAcme. All rights reserved.
//

import UIKit

class AccountSettingsViewController: UIViewController {

    @IBOutlet weak var newUsernameTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var confirmNewPasswordTextField: UITextField!
    @IBOutlet weak var usernameAlreadyExistsLabel: UILabel!
    @IBOutlet weak var passwordsDontMatchLAbel: UILabel!
    @IBOutlet weak var usernameChangedLabel: UILabel!
    @IBOutlet weak var passwordChangedLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.usernameAlreadyExistsLabel.isHidden = true
        self.passwordsDontMatchLAbel.isHidden = true
        self.usernameChangedLabel.isHidden = true
        self.passwordChangedLabel.isHidden = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func changeUsernameTapped(_ sender: UIButton) {
        let username = self.newUsernameTextField.text
        
        if username != "" && username != UserDefaults.standard.string(forKey: "username") {
            self.changeUsername(username: username!)
        }
    }
    
    @IBAction func changePasswordTapped(_ sender: UIButton) {
        let password = newPasswordTextField.text
        let confirmPassword = confirmNewPasswordTextField.text
        
        if password != "" && password == confirmPassword {
            // change password
            self.changePassword(password: password!)
        } else if password != confirmPassword {
            self.passwordsDontMatchLAbel.isHidden = false
        }
    }
    
    func changePassword(password: String) {
        let urlString = "http://localhost:3000/v1/users/" + UserDefaults.standard.string(forKey: "id")!
        let url = URL(string: urlString)
        let session = URLSession.shared
        var request = URLRequest(url: url!)
        request.httpMethod = "PUT"
        
        // Setting data to send
        let paramToSend: [String: Any] = ["password": password as Any, "token": UserDefaults.standard.string(forKey: "token") as Any]
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
                    self.changePasswordDone()
                }
            } else {
                DispatchQueue.main.async {
                    self.passwordsDontMatchLAbel.isHidden = false
                }
            }
        }
        
        task.resume()
    }
    
    func changeUsername(username: String) {
        let urlString = "http://localhost:3000/v1/users/" + UserDefaults.standard.string(forKey: "id")!
        let url = URL(string: urlString)
        let session = URLSession.shared
        var request = URLRequest(url: url!)
        request.httpMethod = "PUT"
        
        // Setting data to send
        let paramToSend: [String: Any] = ["username": username as Any, "token": UserDefaults.standard.string(forKey: "token") as Any]
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
                    self.changeUsernameDone(username: username)
                }
            } else {
                DispatchQueue.main.async {
                    self.usernameAlreadyExistsLabel.isHidden = false
                }
            }
        }
        
        task.resume()
    }
    
    func changeUsernameDone(username: String) {
        UserDefaults.standard.set(username, forKey: "username")
        self.usernameAlreadyExistsLabel.isHidden = true
        self.newUsernameTextField.text = ""
        self.usernameChangedLabel.isHidden = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            self.usernameChangedLabel.isHidden = true
            self.usernameChangedLabel.alpha = 1
        })
        
        // Send notification to update username label in ProfileViewController
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateUsernameAlert"), object: nil)
    }
    
    func changePasswordDone() {
        self.passwordsDontMatchLAbel.isHidden = true
        self.newPasswordTextField.text = ""
        self.confirmNewPasswordTextField.text = ""
        
        self.passwordChangedLabel.isHidden = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            self.passwordChangedLabel.isHidden = true
            self.passwordChangedLabel.alpha = 1
        })
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
