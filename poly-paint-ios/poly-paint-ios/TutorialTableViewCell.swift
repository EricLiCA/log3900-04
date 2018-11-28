//
//  TutorialTableViewCell.swift
//  poly-paint-ios
//
//  Created by Eric Sida Li on 2018-11-28.
//  Copyright © 2018 PolyAcme. All rights reserved.
//

import UIKit

class TutorialTableViewCell: UITableViewCell {
    @IBOutlet weak var tutorialImage: UIImageView!
    @IBOutlet weak var tutorialDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
