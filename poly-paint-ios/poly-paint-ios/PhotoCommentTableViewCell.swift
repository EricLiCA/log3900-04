//
//  PhotoCommentTableViewCell.swift
//  poly-paint-ios
//
//  Created by Eric Sida Li on 2018-11-26.
//  Copyright © 2018 PolyAcme. All rights reserved.
//

import UIKit

class PhotoCommentTableViewCell: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var comment: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
