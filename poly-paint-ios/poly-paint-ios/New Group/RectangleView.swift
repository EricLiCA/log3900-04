//
//  RectangleView.swift
//  poly-paint-ios
//
//  Created by Tomato on 2018-10-30.
//  Copyright © 2018 PolyAcme. All rights reserved.
//

import UIKit

class RectangleView: BasicShapeView {
    
    
    init(frame: CGRect, color: UIColor) {
        super.init(frame: frame, numberOfAnchorPoints: 4, color: color, shapeType: "RECTANGLE")
        self.initGestureRecognizers()
        self.backgroundColor = UIColor.blue
    }
    
    // We need to implement init(coder) to avoid compilation errors
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func draw(_ rect: CGRect) {
        let insetRect = rect.insetBy(dx: lineWidth / 2, dy: lineWidth / 2)
        let path = UIBezierPath(roundedRect: insetRect, cornerRadius: 0)
        self.color?.setFill()
        path.fill()
        path.lineWidth = self.lineWidth
        // self.color?.setStroke()
        path.stroke()
        self.initializeAnchorPoints()
    }
    
    func initializeAnchorPoints() {
        let topAnchorPoint = CGPoint(x: self.frame.size.width/2, y: 0)
        let rightAnchorPoint = CGPoint(x: self.frame.size.width, y: self.frame.size.height/2)
        let bottomAnchorPoint = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height)
        let leftAnchorPoint = CGPoint(x: 0, y: self.frame.size.height/2)
        let anchorPoints = [rightAnchorPoint, bottomAnchorPoint, leftAnchorPoint, topAnchorPoint]
        
        for anchor in anchorPoints {
            let circlePath = UIBezierPath(arcCenter: anchor, radius: CGFloat(7), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = circlePath.cgPath
            shapeLayer.fillColor = UIColor.red.cgColor
            shapeLayer.strokeColor = UIColor.red.cgColor
            shapeLayer.lineWidth = 3.0
            self.anchorPointsLayers.append(shapeLayer)
        }
        
        for anchor in self.anchorPointsLayers {
            self.layer.addSublayer(anchor)
        }
        
        self.hideAnchorPoints()
    }
    
    override func getAnchorPoint(index: Int) -> CGPoint {
        if(index == 0) {
            let rightAnchorPoint = CGPoint(x: self.center.x + self.frame.size.width/2, y: self.center.y)
            return rightAnchorPoint
        } else if (index == 1) {
            let bottomAnchorPoint = CGPoint(x: self.center.x, y: self.center.y + self.frame.size.height/2)
            return bottomAnchorPoint
        } else if(index == 2) {
            let leftAnchorPoint = CGPoint(x: self.center.x - self.frame.size.width/2, y: self.center.y)
            return leftAnchorPoint
        } else if(index == 3) {
            let topAnchorPoint = CGPoint(x: self.center.x, y: self.center.y - self.frame.size.height/2)
            return topAnchorPoint
        } else { // garbage
            return CGPoint(x: 0, y: 0)
        }
    }
}

