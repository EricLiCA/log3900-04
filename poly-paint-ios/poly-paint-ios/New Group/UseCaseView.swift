//
//  UseCaseView.swift
//  poly-paint-ios
//
//  Created by Tomato on 2018-11-14.
//  Copyright © 2018 PolyAcme. All rights reserved.
//

import UIKit

class UseCaseView: EllipseView {

    init(frame: CGRect, text: String) {
        super.init(frame:frame)
        self.backgroundColor = UIColor.clear
        self.initGestureRecognizers()
    }
    
    // We need to implement init(coder) to avoid compilation errors
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
