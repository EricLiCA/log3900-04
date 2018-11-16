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
    var selected = false
    var hitStartPoint: Int?
    var hitEndPoint: Int?
    
    init(layer: CAShapeLayer) {
        self.layer = layer
    }
    
    func hitTest(touchPoint: CGPoint) -> Bool {
        
        for (index, point) in self.points.enumerated() {
            if(index != (self.points.count - 1)) {
                var distanceToSegment = findDistanceToSegment(touchPoint: touchPoint, p1: self.points[index], p2: self.points[index + 1])
                var distanceToPoint = self.findDistanceBetween(p1: touchPoint, p2: point)
                if(distanceToPoint < 10) {
                    print("TOUCHED POINT!!")
                } else if(distanceToSegment > 15) {
                    //return false
                } else if(distanceToSegment < 15) {
                    if(self.selected) {
                        self.hitStartPoint = nil
                        self.hitEndPoint = nil
                        //self.selected = false
                        self.layer?.strokeColor = UIColor.black.cgColor
                    } else {
                        self.hitStartPoint = index
                        self.hitEndPoint = index + 1
                        //self.selected = true
                        self.layer?.strokeColor = UIColor.green.cgColor
                    }
                    
                    return true
                }
            }
        }
        return false
    }
    
    func findDistanceToSegment(touchPoint: CGPoint, p1: CGPoint, p2: CGPoint) -> CGFloat {
        
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
    
    func findDistanceBetween(p1: CGPoint, p2: CGPoint) -> CGFloat {
        let dx = p1.x - p2.x
        let dy = p1.y - p2.y
        return sqrt(dx*dx + dy*dy)
    }
    
    func addPoint(point: CGPoint) {
        self.points.insert(point, at: self.hitStartPoint! + 1)
        self.hitEndPoint = self.hitEndPoint! + 1
    }
    
    
}
