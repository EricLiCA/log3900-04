//
//  StickFigureViewController.swift
//  poly-paint-ios
//
//  Created by Tomato on 2018-11-21.
//  Copyright © 2018 PolyAcme. All rights reserved.
//

import UIKit

class StickFigureViewController: UIViewController {

    @IBOutlet weak var actorName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.actorName.text = ""
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func insertActorTapped(_ sender: UIButton) {
        self.sendStickFigureInfo()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func sendStickFigureInfo() {
        let userInfo = ["actorName": self.actorName.text] as [String : Any]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "createStickFigureAlert"), object: nil, userInfo: userInfo)
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
