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
        print("touch began")
        lastPoint = touches.first?.location(in: self)
        self.setNeedsDisplay()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        /*let newPoint = touches.first?.location(in: self)
        lines.append(Line(start: lastPoint, end: newPoint!))
        lastPoint = newPoint
        
        self.setNeedsDisplay()*/
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        /*print("Touch ended!")
        let newPoint = touches.first?.location(in: self)
        lines.append(Line(start: lastPoint, end: newPoint!))
        lastPoint = newPoint
        
        self.setNeedsDisplay()*/
    }
    
    
    override func draw(_ rect: CGRect) {
        print("Draw called")
        print(rect)
        
        // Add the view to the view hierarchy so that it shows up on screen
        /*let context = UIGraphicsGetCurrentContext()
        context!.beginPath()
        for line in lines {
            let startPoint = CGPoint(x: line.start.x, y: line.start.y)
            context!.move(to: startPoint)
            let endPoint = CGPoint(x: line.end.x, y: line.end.y)
            context!.addLine(to: endPoint)
            
        }
        context!.setLineCap(CGLineCap.round)
        context!.setStrokeColor(cyan: 0, magenta: 0, yellow: 0, black: 1, alpha: 1)
        context!.setLineWidth(5) // make line thicker
        context!.strokePath()*/
        
    }
}
