//
//  PrivateImageViewController.swift
//  poly-paint-ios
//
//  Created by JP Cech on 10/28/18.
//  Copyright © 2018 PolyAcme. All rights reserved.
//

import UIKit

class PrivateImageViewController: UIViewController {
    var image: Image?
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageProtectionLevelLabel: UILabel!
    @IBOutlet weak var editBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image?.fullImage
        imageProtectionLevelLabel.text = image?.protectionLevel
        self.navigationItem.title = image?.title
    }
    
    @IBAction func editImage(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let openEditorAction = UIAlertAction(title: "Open In Editor", style: .default, handler: { (alert: UIAlertAction!) -> Void in
            //  Do some destructive action here.
        })
        alertController.addAction(openEditorAction)
        
        if image?.protectionLevel != "public" {
            let makePublicAction = UIAlertAction(title: "Set As Public", style: .default, handler: { (alert: UIAlertAction!) -> Void in
                //  Do some action here.
            })
            alertController.addAction(makePublicAction)
        }
        
        if image?.protectionLevel != "private" {
            let makePrivateAction = UIAlertAction(title: "Set As Private", style: .default, handler: { (alert: UIAlertAction!) -> Void in
                //  Do some destructive action here.
            })
            alertController.addAction(makePrivateAction)
        }
        
        if image?.protectionLevel != "protected" {
            let makeProtectedAction = UIAlertAction(title: "Set As Protected", style: .default, handler: { (alert: UIAlertAction!) -> Void in
                self.performSegue(withIdentifier: "toChangeImagePassword", sender: self)
            })
            alertController.addAction(makeProtectedAction)
        }
        
        if image?.protectionLevel == "protected" {
            let changePasswordAction = UIAlertAction(title: "Change Password", style: .default, handler: { (alert: UIAlertAction!) -> Void in
                self.performSegue(withIdentifier: "toChangeImagePassword", sender: self)
            })
            alertController.addAction(changePasswordAction)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: { (alert: UIAlertAction!) -> Void in
            //  Do something here upon cancellation.
        })
        alertController.addAction(cancelAction)
        
        
        
        if let popoverController = alertController.popoverPresentationController {
            popoverController.barButtonItem = sender
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toChangeImagePassword" {
           let ProtectedImagePasswordVC = segue.destination as! ProtectedImagePasswordViewController
            ProtectedImagePasswordVC.image = self.image
        }
    }
    
}

/*if image?.protectionLevel != "public" {
 let makePublicAction = UIAlertAction(title: "Public", style: .default, handler: { (alert: UIAlertAction!) -> Void in
 //  Do some action here.
 })
 alertController.addAction(makePublicAction)
 }
 if image?.protectionLevel != "private" {
 let makePrivateAction = UIAlertAction(title: "Private", style: .default, handler: { (alert: UIAlertAction!) -> Void in
 //  Do some destructive action here.
 })
 alertController.addAction(makePrivateAction)
 }
 
 if image?.protectionLevel != "protected" {
 let makeProtectedAction = UIAlertAction(title: "Protective", style: .default, handler: { (alert: UIAlertAction!) -> Void in
 //  Do some destructive action here.
 })
 alertController.addAction(makeProtectedAction)
 }
 
 let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: { (alert: UIAlertAction!) -> Void in
 //  Do something here upon cancellation.
 })
 alertController.addAction(cancelAction)*/

/*if let popoverController = alertController.popoverPresentationController {
 popoverController.sourceView = self.view
 popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
 popoverController.permittedArrowDirections = []
 }*/
