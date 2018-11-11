//
//  Anchor.swift
//  poly-paint-ios
//
//  Created by Tomato on 2018-11-10.
//  Copyright © 2018 PolyAcme. All rights reserved.
//

import Foundation
import UIKit

class Anchor {
    var toUUID: String?
    var fromUUID: String?
    var toAnchorNumber: Int?
    var fromAnchorNumber: Int?
    var fromPoint: CGPoint?
    var toPoint: CGPoint?
    
    init(fromUUID: String, fromAnchorNumber: Int, fromPoint: CGPoint) {
        self.fromUUID = fromUUID
        self.fromAnchorNumber = fromAnchorNumber
        self.fromPoint = fromPoint
    }
    
    public func setToUUID(toUUID: String, toAnchorNumber: Int, toPoint: CGPoint) {
        self.toUUID = toUUID
        self.toAnchorNumber = toAnchorNumber
        self.toPoint = toPoint
    }
    
}
