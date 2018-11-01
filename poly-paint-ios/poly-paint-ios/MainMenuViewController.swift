//
//  MainMenuViewController.swift
//  poly-paint-ios
//
//  Created by Tomato on 2018-10-03.
//  Copyright © 2018 PolyAcme. All rights reserved.
//

import UIKit

class MainMenuViewController: UIViewController {
    
    @IBOutlet weak var chatButton: UIButton!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var galleryButton: UIButton!
    @IBOutlet weak var newImageButton: UIButton!
    
    let io = SocketService.instance.socketIOClient!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        io.on(clientEvent: .connect) {data, ack in
            self.io.emit("setUsername", UserManager.instance.username)
        }
        io.on("setUsernameStatus") { (data, ack) in
            if (data[0] as! String == "Username already taken!") {
                print(data[0])
            } else {
                print("Set username succeeded")
            }
        }
        io.connect()
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Logout", style: UIBarButtonItemStyle.plain, target: self, action: #selector(MainMenuViewController.back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
        self.checkIfAnonymous()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func back(sender: UIBarButtonItem) {
        // Go back to the previous ViewController and clear UserDefaults
        self.resetDefaults()
        _ = navigationController?.popViewController(animated: true)
    }
    
    func resetDefaults() {
        UserManager.instance.reset()
        io.disconnect()
    }
    
    func checkIfAnonymous() {
        if UserManager.instance.id == nil {
            self.blockProfile()
        }
    }
    
    func blockProfile() {
        self.profileButton.isEnabled = false
        self.profileButton.isHidden = true
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
