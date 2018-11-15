//
//  Line.swift
//  poly-paint-ios
//
//  Created by Tomato on 2018-11-13.
//  Copyright © 2018 PolyAcme. All rights reserved.
//

import Foundation
import UIKit

enum Relation {
    case Composition
    case Association
    case Aggregation
    case Inheritance
}

class Line {
    
    var layer: CAShapeLayer?
    var points = [CGPoint]()
    var firstAnchorShapeId: String?
    var firstAnchorShapeIndex: Int?
    var secondAnchorShapeId: String?
    var secondAnchorShapeIndex: Int?
    
    var firstEndLabel: String?
    var firstEndRelation: String?
    var secondEndLabel: String?
    var secondEndRelation: String?
    
    init(layer: CAShapeLayer) {
        self.layer = layer
    }
    
    func hitTest(touchPoint: CGPoint) -> Bool {
        var distanceToSegment = findDistanceToSegment(touchPoint: touchPoint)
        if(distanceToSegment > 15) {
            return false
        } else {
            return true
        }
    }
    
    func findDistanceToSegment(touchPoint: CGPoint) -> CGFloat {
        var p1 = self.points[0]
        var p2 = self.points[1]
        
        var dx = p2.x - p1.x
        var dy = p2.y - p1.y
        
        if((dx == 0) && (dy == 0)) {
            dx = touchPoint.x - p1.x
            dy = touchPoint.y - p1.y
        }
        
        var t = ((touchPoint.x - p1.x)*dx + (touchPoint.y - p1.y)*dy) / (dx * dx + dy * dy)
        
        if(t < 0) {
            var closest = CGPoint(x: p1.x, y: p2.y)
            dx = touchPoint.x - p1.x
            dy = touchPoint.y - p1.y
        } else if(t > 1) {
            var closest = CGPoint(x: p2.x, y: p2.y)
            dx = touchPoint.x - p2.x
            dy = touchPoint.y - p2.y
        } else {
            var closest = CGPoint(x: p1.x + t*dx, y: p1.y + t*dy)
            dx = touchPoint.x - closest.x
            dy = touchPoint.y - closest.y
        }
        
        return sqrt(dx*dx + dy*dy)
        
    }
}
