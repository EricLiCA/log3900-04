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
            self.signUpFailedLabel.isHidden = false
        } else {
            // TODO: signUp(username!, password!)
            signUpSuccessLabel.isHidden = false
            UIView.animate( withDuration: 3, animations: { () -> Void in self.signUpFailedLabel.alpha = 0})
            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                self.signUpSuccessLabel.isHidden = true
                self.signUpSuccessLabel.alpha = 1
            })
            
            self.resetFieldsAndLabels()
        }
    }
    
    // TODO: Modify function when API ready
    func signUp(_ username: String, _ password: String) {
        let url = URL(string: "http://ec2-18-214-40-211.compute-1.amazonaws.com")
        let session = URLSession.shared
        
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "POST"
        
        let paramToSend = "username" + username + "&password" + password
        request.httpBody = paramToSend.data(using: String.Encoding.utf8)
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {
            (data, response, error) in
            guard let _:Data = data else {
                return
            }
            
            let json:Any?
            
            do {
                json = try JSONSerialization.jsonObject(with: data!, options: [])
            }
            catch {
                return
            }
            guard let serverResponse = json as? NSDictionary else {
                return
            }
            
            if let dataBlock = serverResponse["data"] as? NSDictionary {
                if (dataBlock["session"] as? String) != nil {
                    DispatchQueue.main.async {
                        // segue successful login
                    }
                }
            }
        })
        
        task.resume()
    }
    
    func resetFieldsAndLabels() {
        usernameTextField.text = ""
        passwordTextField.text = ""
        confirmPasswordTextField.text = ""
        signUpFailedLabel.isHidden = true
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
