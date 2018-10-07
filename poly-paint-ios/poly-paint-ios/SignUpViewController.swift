//
//  SignUpViewController.swift
//  poly-paint-ios
//
//  Created by Tomato on 2018-10-06.
//  Copyright © 2018 PolyAcme. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var _confirmPassword: UITextField!
        @IBOutlet weak var _password: UITextField!
    @IBOutlet weak var _username: UITextField!
    
    @IBOutlet weak var _signUpSuccessNotice: UILabel!
    @IBOutlet weak var _signUpFailedNotice: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _signUpFailedNotice.isHidden = true
        _signUpSuccessNotice.isHidden = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signUp(_ sender: UIButton) {
        let username = _username.text
        let password = _password.text
        let confirmPassword = _confirmPassword.text
        
        if username == "" || password == "" || confirmPassword == "" {
            self._signUpFailedNotice.isHidden = false
        } else if password != confirmPassword {
            self._signUpFailedNotice.isHidden = false
        } else {
            //signUp(username!, password!)
            _signUpSuccessNotice.isHidden = false
            UIView.animate( withDuration: 5, animations: { () -> Void in self._signUpSuccessNotice.alpha = 0})
            self.resetFieldsAndLabels()
        }
    }
    
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
        _username.text = ""
        _password.text = ""
        _confirmPassword.text = ""
        _signUpFailedNotice.isHidden = true
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
