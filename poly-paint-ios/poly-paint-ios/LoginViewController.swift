//
//  LoginViewController.swift
//  poly-paint-ios
//
//  Created by Tomato on 2018-10-03.
//  Copyright © 2018 PolyAcme. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var authenticationFailedLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authenticationFailedLabel.isHidden = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loginTapped(_ sender: UIButton) {
        let username = usernameTextField.text
        let password = passwordTextField.text
        if username != "" && password != "" {
            login(username!, password!)
        } else  {
            self.authenticationFailed()
        }
    }
    
    @IBAction func anonymousLogin(_ sender: UIButton) {
        UserDefaults.standard.set("anonymous", forKey: "username")
        UserDefaults.standard.set(nil, forKey: "id")
        UserDefaults.standard.set(nil, forKey: "token")
        performSegue(withIdentifier: "toMainMenu", sender: self)
    }
    
    func login(_ user: String, _ psw: String) {
        let url = URL(string: "http://localhost:3000/v2/sessions")
        let session = URLSession.shared
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        
        // Setting data to send
        let paramToSend: [String: Any] = ["username": user, "password": psw]
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
                    UserDefaults.standard.set(user, forKey: "username")
                    UserDefaults.standard.set(responseJSON["id"], forKey: "id")
                    UserDefaults.standard.set(responseJSON["token"], forKey: "token")
                    UserDefaults.standard.set(responseJSON["profileImage"], forKey: "profileImage")
                    print("PICTURE!")
                    print(UserDefaults.standard.string(forKey: "profileImage"))
                    self.loginDone()
                }
            } else {
                DispatchQueue.main.async {
                    self.authenticationFailed()
                }
            }
        }
        
        task.resume()
    }
    
    func loginDone() {
        self.resetFieldsAndLabels()
        performSegue(withIdentifier: "toMainMenu", sender: self)
    }
    
    func resetFieldsAndLabels() {
        usernameTextField.text = ""
        passwordTextField.text = ""
        authenticationFailedLabel.isHidden = true
    }
    
    func authenticationFailed() {
        passwordTextField.text = ""
        authenticationFailedLabel.isHidden = false
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
