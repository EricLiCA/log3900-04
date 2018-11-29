//
//  TutorialViewController.swift
//  poly-paint-ios
//
//  Created by Eric Sida Li on 2018-11-28.
//  Copyright © 2018 PolyAcme. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController {
    @IBOutlet weak var tutorialImage: UIImageView!
    var imageToDisplay: UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        tutorialImage.image = imageToDisplay
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
