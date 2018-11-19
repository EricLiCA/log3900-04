//
//  CreateNewImageViewController.swift
//  poly-paint-ios
//
//  Created by JP Cech on 11/19/18.
//  Copyright © 2018 PolyAcme. All rights reserved.
//

import UIKit

class CreateNewImageViewController: UIViewController {
    
    
    @IBOutlet weak var imageTitle: UITextField!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var passwordStack: UIStackView!
    @IBOutlet weak var passMatch: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.passwordStack.isHidden = true;
        self.passMatch.isHidden = true;
    }
    
    @IBAction func onTapProtection(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
             self.passwordStack.isHidden = true
            break
        case 1:
            self.passwordStack.isHidden = true
            break
        case 2:
            self.passwordStack.isHidden = false
        default:
            break
        }
    }
}
