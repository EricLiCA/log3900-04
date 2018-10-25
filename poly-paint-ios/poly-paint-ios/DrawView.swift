//
//  DrawView.swift
//  poly-paint-ios
//
//  Created by Tomato on 2018-10-25.
//  Copyright © 2018 PolyAcme. All rights reserved.
//

import UIKit


class DrawView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var lines = [Line]()
    var lastPoint: CGPoint!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastPoint = touches.first?.location(in: self)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        var newPoint = touches.first?.location(in: self)
        lines.append(Line(start: lastPoint, end: newPoint!))
        lastPoint = newPoint
    }
    
    override func draw(_ rect: CGRect) {
        var context = UIGraphicsGetCurrentContext()
        context!.beginPath()
        for line in lines {
            var startPoint = CGPoint(x: line.start.x, y: line.start.y)
            context!.move(to: startPoint)
            var endPoint = CGPoint(x: line.end.x, y: line.end.y)
            context!.addLine(to: endPoint)
            
        }
    }
}
