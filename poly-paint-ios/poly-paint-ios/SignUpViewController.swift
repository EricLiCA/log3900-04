//
//  SignUpViewController.swift
//  poly-paint-ios
//
//  Created by Tomato on 2018-10-06.
//  Copyright © 2018 PolyAcme. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var signUpSuccessLabel: UILabel!
    @IBOutlet weak var signUpFailedLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signUpFailedLabel.isHidden = true
        signUpSuccessLabel.isHidden = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // TODO: Modify function when API ready
    @IBAction func signUp(_ sender: UIButton) {
        let username = usernameTextField.text
        let password = passwordTextField.text
        let confirmPassword = confirmPasswordTextField.text
        
        if username == "" || password == "" || confirmPassword == "" || password != confirmPassword {
            self.signUpFailed()
        } else {
            self.signUp(username!, password!)
        }
    }
    
    // TODO: Modify function when API ready
    func signUp(_ username: String, _ password: String) {
        let url = URL(string: "http://localhost:3000/v1/users")
        let session = URLSession.shared
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        
        // Setting data to send
        let paramToSend: [String: Any] = ["username": username, "password": password]
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
                    self.signUpDone()
                }
            } else {
                DispatchQueue.main.async {
                    self.signUpFailed()
                }
            }
        }
        
        task.resume()
    }
    
    func resetFieldsAndLabels() {
        usernameTextField.text = ""
        passwordTextField.text = ""
        confirmPasswordTextField.text = ""
        signUpFailedLabel.isHidden = true
    }
    
    func signUpFailed() {
        self.signUpFailedLabel.isHidden = false
    }
    
    func signUpDone() {
        signUpSuccessLabel.isHidden = false
        UIView.animate( withDuration: 3, animations: { () -> Void in self.signUpFailedLabel.alpha = 0})
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            self.signUpSuccessLabel.isHidden = true
            self.signUpSuccessLabel.alpha = 1
        })
        
        self.resetFieldsAndLabels()
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
