//
//  PublicImageViewController.swift
//  poly-paint-ios
//
//  Created by JP Cech on 10/28/18.
//  Copyright © 2018 PolyAcme. All rights reserved.
//

import UIKit

class PublicImageViewController: UIViewController {
    
    var image: Image?
    var enteredPassword: String?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageProtectionLevelLabel: UILabel!
    @IBOutlet weak var editBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateView()
        
    }
    
    func updateView () {
        imageView.image = image?.fullImage
        imageProtectionLevelLabel.text = image?.protectionLevel
        self.navigationItem.title = image?.title
    }
    
    @IBAction func editImage(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let openEditorAction = UIAlertAction(title: "Open In Editor", style: .default, handler: { (alert: UIAlertAction!) -> Void in
            if (self.image?.protectionLevel! == "protected") {
                self.askCorrectPassword()
            }
        })
        alertController.addAction(openEditorAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: { (alert: UIAlertAction!) -> Void in
        })
        alertController.addAction(cancelAction)
        
        if let popoverController = alertController.popoverPresentationController {
            popoverController.barButtonItem = sender
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func askCorrectPassword() -> Void {
        let alertPassword = UIAlertController(title: "Open protected image", message: "Enter password", preferredStyle: UIAlertControllerStyle.alert)
        
        alertPassword.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.placeholder = "Enter password"
            textField.isSecureTextEntry = true // for password input
        })
        let confirmPassword = UIAlertAction(title: "Ok", style: .default, handler: { (alert: UIAlertAction!) -> Void in
            if(self.checkCorrectPassword(password: alertPassword.textFields![0].text!)) {
                self.performSegue(withIdentifier: "toImageEditorWithExistingImage", sender: self)
            }
            else {
                alertPassword.message = "Invalid password"
                self.present(alertPassword, animated: true, completion: nil)
                let message  = "Invalid password"
                //hack to change message color
                alertPassword.setValue(NSAttributedString(string: message, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 17),NSAttributedStringKey.foregroundColor : UIColor.red]), forKey: "attributedMessage")
            }
            
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: { (alert: UIAlertAction!) -> Void in
        })
        alertPassword.addAction(cancelAction)
        alertPassword.addAction(confirmPassword)
        self.present(alertPassword, animated: true, completion: nil)
    }
    
    func checkCorrectPassword (password: String) -> Bool {
        return password == self.image?.password!
    }
}
