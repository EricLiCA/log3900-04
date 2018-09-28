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
    
    // MARK: - Initialization and Cleanup
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Send username and server address to ChatViewController
        guard segue.destination is ChatViewController else { return }
        let destinationVC = segue.destination as! ChatViewController
        destinationVC.username = username.text!
        destinationVC.serverAddress = serverAddress.text!
    }
    
    // MARK: - Actions
    @IBAction func joinChatButton(_ sender: UIButton) {
        if serverAddress.text! != "", username.text! != "" {
            performSegue(withIdentifier: "toChat", sender: self)
        }
    }
}
