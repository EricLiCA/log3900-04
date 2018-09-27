//
//  ConnectionViewController.swift
//  poly-paint-ios
//
//  Created by Eric Sida Li on 2018-09-25.
//  Copyright © 2018 PolyAcme. All rights reserved.
//

import UIKit

class ConnectionViewController: UIViewController {
    @IBOutlet weak var serverAddress: UITextField!
    @IBOutlet weak var username: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.destination is ViewController else { return }
        let destinationVC = segue.destination as! ViewController
        destinationVC.username = username.text!
        destinationVC.serverAddress = serverAddress.text!
    }
    
    @IBAction func joinChatButton(_ sender: UIButton) {
        if serverAddress.text! != "", username.text! != "" {
            performSegue(withIdentifier: "toChat", sender: self)
        }
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
