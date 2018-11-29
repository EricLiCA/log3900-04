//
//  UseCasePopoverViewController.swift
//  poly-paint-ios
//
//  Created by Tomato on 2018-11-21.
//  Copyright © 2018 PolyAcme. All rights reserved.
//

import UIKit

class UseCasePopoverViewController: UIViewController {

    @IBOutlet weak var useCaseTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.useCaseTextView.text = ""
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func createUseCaseTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        self.sendUseCase()
    }
    
    @IBAction func cancelTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func sendUseCase() {
        let userInfo = ["useCase": self.useCaseTextView.text] as [String : Any]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "createUseCaseAlert"), object: nil, userInfo: userInfo)
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
