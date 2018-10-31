//
//  ConnectionViewController.swift
//  poly-paint-ios
//
//  Created by Eric Sida Li on 2018-09-25.
//  Copyright © 2018 PolyAcme. All rights reserved.
//

import UIKit

class ConnectionViewController: UIViewController {
    // MARK: - View Elements
    @IBOutlet weak var serverAddress: UITextField!
    @IBOutlet weak var username: UITextField!
    
    var pseudonym: String = ""
    
    // MARK: - Initialization and Cleanup
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set username
        self.pseudonym = UserManager.instance.username
        if (self.pseudonym != "anonymous") {
            self.username.text = self.pseudonym
            self.username.isEnabled = false
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Send username and server address to ChatViewController
        if (self.pseudonym == "anonymous") {
            UserManager.instance.username = "anonymous " + self.username.text!
        }
        
        guard segue.destination is ChatViewController else { return }
        let destinationVC = segue.destination as! ChatViewController
        destinationVC.username = UserManager.instance.username
        SocketService.instance.serverAddress = serverAddress.text!
    }
    
    // MARK: - Actions
    @IBAction func joinChatButton(_ sender: UIButton) {
        if serverAddress.text! != "", username.text! != "" {
            performSegue(withIdentifier: "toChat", sender: self)
        }
    }
}
