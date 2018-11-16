//
//  MainMenuViewController.swift
//  poly-paint-ios
//
//  Created by Tomato on 2018-10-03.
//  Copyright © 2018 PolyAcme. All rights reserved.
//

import UIKit

class MainMenuViewController: UIViewController {
    
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var galleryButton: UIButton!
    @IBOutlet weak var newImageButton: UIButton!
    @IBOutlet weak var chatButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ChatModel.instance.notificationsSubject.asObservable().subscribe(onNext: {
            notifications in
            if notifications == 0 {
                self.chatButton.image = #imageLiteral(resourceName: "Chat")
            } else {
                self.chatButton.image = #imageLiteral(resourceName: "UnreadMessage")
            }
        })
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Logout", style: UIBarButtonItemStyle.plain, target: self, action: #selector(MainMenuViewController.back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
        self.checkIfAnonymous()
        print("Set username as \(UserDefaults.standard.string(forKey: "username")!)")
            ChatModel.instance.setUsername(username: UserDefaults.standard.string(forKey: "username")!)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func back(sender: UIBarButtonItem) {
        // Go back to the previous ViewController and clear UserDefaults
        ChatModel.instance.socketIOClient.disconnect()
        ChatModel.instance = ChatModel()
        self.resetDefaults()
        _ = navigationController?.popViewController(animated: true)
    }
    
    func resetDefaults() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
    }
    
    func checkIfAnonymous() {
        if UserDefaults.standard.string(forKey: "id") == nil {
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
