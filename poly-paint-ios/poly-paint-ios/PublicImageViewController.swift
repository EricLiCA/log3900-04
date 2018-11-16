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
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageProtectionLevelLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateView()
        
    }
    func updateView () {
        imageView.image = image?.fullImage
        imageProtectionLevelLabel.text = image?.protectionLevel
        self.navigationItem.title = image?.title
    }
    
    
    
}
