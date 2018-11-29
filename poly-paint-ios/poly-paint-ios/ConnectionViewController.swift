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
    @IBOutlet weak var notificationsLabel: UILabel!
    
    var pseudonym: String = ""
    
    // MARK: - Initialization and Cleanup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set username
        self.pseudonym = UserDefaults.standard.string(forKey: "username") ?? ""
        if (self.pseudonym != "anonymous") {
            self.username.text = self.pseudonym
            self.username.isEnabled = false
        }
        
        notificationsLabel.text = "NotificationsTest: \(ChatModel.instance.notifications)"
        ChatModel.instance.notificationsSubject.asObservable().subscribe(onNext: {
            notifications in
            self.notificationsLabel.text = "Notifications: \(notifications)"
            if notifications == 0 {
                self.notificationsLabel.isHidden = true
            } else {
                self.notificationsLabel.isHidden = false
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Send username and server address to ChatViewController
        if (self.pseudonym == "anonymous") {
            UserDefaults.standard.set("anonymous " + self.username.text!, forKey: "username")
        }
        
        guard segue.destination is ChatViewController else { return }
        let destinationVC = segue.destination as! ChatViewController
        destinationVC.username = UserDefaults.standard.string(forKey: "username")!
        destinationVC.serverAddress = serverAddress.text!
    }
    
    // MARK: - Actions
    @IBAction func joinChatButton(_ sender: UIButton) {
        if serverAddress.text! != "", username.text! != "" {
            performSegue(withIdentifier: "toChat", sender: self)
        }
    }
}
