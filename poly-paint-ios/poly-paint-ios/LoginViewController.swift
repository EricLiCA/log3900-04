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

    // TODO: Call login() when API ready
    @IBAction func loginTapped(_ sender: UIButton) {
        let username = usernameTextField.text
        let password = passwordTextField.text
        if username != "" && password != "" {
            performSegue(withIdentifier: "toMainMenu", sender: self)
            //TODO: Call login(username!, password!)
        } else  {
            authenticationFailedLabel.isHidden = false
        }
    }
    
    @IBAction func anonymousLogin(_ sender: UIButton) {
        UserDefaults.standard.set("anonymous", forKey: "username")
        performSegue(withIdentifier: "toMainMenu", sender: self)
    }
    
    // TODO: Modify function when api ready
    func login(_ user: String, _ psw: String) {
        let url = URL(string: "http://ec2-18-214-40-211.compute-1.amazonaws.com")
        let session = URLSession.shared
        
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "POST"
        
        let paramToSend = "username" + user + "&password" + psw
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
                if let sessionData = dataBlock["session"] as? String {
                    let preferences = UserDefaults.standard
                    preferences.set(sessionData, forKey: "session")
                    
                    DispatchQueue.main.async {
                        self.loginDone()
                    }
                }
            }
        })
        
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
