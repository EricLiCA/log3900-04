//
//  NewClassViewController.swift
//  poly-paint-ios
//
//  Created by JP Cech on 11/16/18.
//  Copyright © 2018 PolyAcme. All rights reserved.
//
import UIKit

class NewClassViewController: UIViewController {
    
    @IBOutlet weak var rawText: UITextView!
    @IBOutlet weak var addClassBtn: UIButton!
    
    override func viewDidLoad() {
     super.viewDidLoad()
     self.rawText.text = "Class Name\n--\nAttributes\n--\nMethods"
     }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func addClassTapped(_ sender: UIButton) {
        self.sendCreateClassDiagramNotification()
        
    }
    
    func sendCreateClassDiagramNotification() {
        let userInfo = [ "text" : rawText.text! ]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "createClassDiagramAlert"), object: nil, userInfo: userInfo)
        self.dismiss(animated: true, completion: nil)
    }
}
