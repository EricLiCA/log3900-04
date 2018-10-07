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
            UIView.animate( withDuration: 3, animations: { () -> Void in self._signUpSuccessNotice.alpha = 0})
            self.resetFieldsAndLabels()
            //performSegue(withIdentifier: "toMainMenu", sender: self)
        }
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
