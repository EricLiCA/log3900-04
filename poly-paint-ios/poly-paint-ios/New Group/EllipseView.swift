//
//  EllipseView.swift
//  poly-paint-ios
//
//  Created by Tomato on 2018-10-30.
//  Copyright © 2018 PolyAcme. All rights reserved.
//

import UIKit

class EllipseView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    let defaultSize: CGFloat = 150.0
    let lineWidth: CGFloat = 1
    let uuid = NSUUID.init().uuidString.lowercased()
    
    init(frame: CGRect, layer: CALayer) {
        super.init(frame:frame)
        //self.center = origin
        self.backgroundColor = UIColor.clear
        initGestureRecognizers()
    }
    
    // We need to implement init(coder) to avoid compilation errors
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initGestureRecognizers() {
        let panGR = UIPanGestureRecognizer(target: self, action: #selector(didPan(panGR:)))
        addGestureRecognizer(panGR)
        let pinchGR = UIPinchGestureRecognizer(target: self, action: #selector(didPinch(pinchGR:)))
        addGestureRecognizer(pinchGR)
        let rotationGR = UIRotationGestureRecognizer(target: self, action: #selector(didRotate(rotationGR:)))
        addGestureRecognizer(rotationGR)
    }
    
    override func draw(_ rect: CGRect) {
        let insetRect = rect.insetBy(dx: lineWidth / 2, dy: lineWidth / 2)
        let path = UIBezierPath(ovalIn: insetRect)
        UIColor.white.setFill()
        path.fill()
        path.lineWidth = self.lineWidth
        UIColor.black.setStroke()
        path.stroke()
    }
    
    @objc func didPan(panGR: UIPanGestureRecognizer) {
        self.superview!.bringSubview(toFront: self)
        var translation = panGR.translation(in: self)
        translation = translation.applying(self.transform)
        self.center.x += translation.x
        self.center.y += translation.y
        panGR.setTranslation(.zero, in: self)
    }
    
    @objc func didPinch(pinchGR: UIPinchGestureRecognizer) {
        if pinchGR.state == .changed{
            let p1: CGPoint = pinchGR.location(ofTouch: 0, in: self)
            let p2: CGPoint = pinchGR.location(ofTouch: 1, in: self)
            var x_scale = pinchGR.scale;
            var y_scale = pinchGR.scale;
            
            if axisFromPoints(p1: p1,p2) == "x" {
                y_scale = 1;
                x_scale = pinchGR.scale
            }
            
            if axisFromPoints(p1: p1, p2) == "y" {
                x_scale = 1;
                y_scale = pinchGR.scale
            }
            
            self.transform = self.transform.scaledBy(x: x_scale, y: y_scale)
            pinchGR.scale = 1
        }
    }
    
    @objc func didRotate(rotationGR: UIRotationGestureRecognizer) {
        self.superview!.bringSubview(toFront: self)
        let rotation = rotationGR.rotation
        self.transform = self.transform.rotated(by: rotation)
        rotationGR.rotation = 0.0
    }
    
    func axisFromPoints(p1: CGPoint, _ p2: CGPoint) -> String {
        let x_1 = p1.x
        let x_2 = p2.x
        let y_1 = p1.y
        let y_2 = p2.y
        let absolutePoint = CGPoint(x: x_2 - x_1, y: y_2 - y_1)
        let radians = atan2(Double(absolutePoint.x), Double(absolutePoint.y))
        let absRad = fabs(radians)
        
        if absRad > (.pi / 4) && absRad < 3*(.pi / 4) {
            return "x"
        } else {
            return "y"
        }
    }

}
