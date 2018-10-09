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
    @IBOutlet weak var oldPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var confirmNewPasswordTextField: UITextField!

    @IBOutlet weak var usernameAlreadyExistsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.usernameAlreadyExistsLabel.isHidden = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func changeUsernameTapped(_ sender: UIButton) {
        
        // send request to server
        
        // If success (username doesn't exist), update userDefault
        
        // If failure (username exists), show failure label
        self.usernameAlreadyExistsLabel.isHidden = false
    }
    
    @IBAction func changePasswordTapped(_ sender: UIButton) {
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
