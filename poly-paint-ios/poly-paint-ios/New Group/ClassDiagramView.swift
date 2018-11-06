//
//  ClassDiagramView.swift
//  poly-paint-ios
//
//  Created by Tomato on 2018-11-04.
//  Copyright © 2018 PolyAcme. All rights reserved.
//

import UIKit

class ClassDiagramView: UIView {
    let lineWidth: CGFloat = 1
    let uuid = NSUUID.init().uuidString.lowercased()
    var lastRotation: CGFloat = 0
    var originalRotation = CGFloat()
    var anchorPointsLayers = [CAShapeLayer]()
    let defaultTextLineHeight: CGFloat = 40
    let defaultMaxNumOfLines = 5
    let textGap: CGFloat = 5

    
    init(frame: CGRect, layer: CALayer) {
        super.init(frame: frame)
        layer.backgroundColor = UIColor.blue.cgColor
        initGestureRecognizers()
        self.backgroundColor = UIColor.blue
        //self.setNeedsDisplay()
        
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
        let insetRect = rect.insetBy(dx: lineWidth, dy: lineWidth)
        let path = UIBezierPath(roundedRect: insetRect, cornerRadius: 0)
        UIColor.white.setFill()
        path.fill()
        path.lineWidth = self.lineWidth
        UIColor.black.setStroke()
        path.stroke()
        self.initializeAnchorPoints()
        self.initializeTextFields(words: ["Class Name \n blablabala this is a long text \n yes", "Attributs popopopopopopo \n tatatata", "Methods"])
    }
    
    @objc func didPan(panGR: UIPanGestureRecognizer) {
        self.superview!.bringSubview(toFront: self)
        var translation = panGR.translation(in: self)
        translation = translation.applying(self.transform)
        self.center.x += translation.x
        self.center.y += translation.y
        panGR.setTranslation(.zero, in: self)
        
        if(panGR.state == .ended) {
            self.hideAnchorPoints()
        } else if(panGR.state == .began) {
            self.showAnchorPoints()
        }
        
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
    
    func initializeAnchorPoints() {
        let topAnchorPoint = CGPoint(x: self.frame.size.width/2, y: 0)
        let rightAnchorPoint = CGPoint(x: self.frame.size.width, y: self.frame.size.height/2)
        let bottomAnchorPoint = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height)
        let leftAnchorPoint = CGPoint(x: 0, y: self.frame.size.height/2)
        var anchorPoints = [topAnchorPoint, rightAnchorPoint, bottomAnchorPoint, leftAnchorPoint]
        
        for anchor in anchorPoints {
            var circlePath = UIBezierPath(arcCenter: anchor, radius: CGFloat(3), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
            var shapeLayer = CAShapeLayer()
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
    
    func showAnchorPoints() {
        for index in 0...3 {
            self.layer.sublayers![index].isHidden = false
        }
    }
    
    func hideAnchorPoints() {
        for index in 0...3 {
            self.layer.sublayers![index].isHidden = true
        }
    }
    
    func initializeTextFields(words: [String]) {
        var currentHeight = CGFloat(0)
        for word in words {
            // draw ligne
            let fromPoint = CGPoint(x: 0, y: currentHeight)
            let toPoint = CGPoint(x: self.frame.width, y: currentHeight)
            self.drawLine(fromPoint: fromPoint, toPoint: toPoint)
            // set label
            let label = UILabel(frame: CGRect(x: self.textGap, y: currentHeight, width: self.frame.width, height: self.defaultTextLineHeight))
            label.contentMode = .scaleToFill
            label.numberOfLines = self.defaultMaxNumOfLines
            label.text = word
            label.lineBreakMode = NSLineBreakMode.byWordWrapping
            label.sizeToFit()
            currentHeight += label.frame.height
            self.addSubview(label)
        }
    }
    
    func drawLine(fromPoint: CGPoint, toPoint: CGPoint) {
        let aPath = UIBezierPath()
        aPath.move(to: fromPoint)
        aPath.addLine(to: toPoint)
        //Keep using the method addLineToPoint until you get to the one where about to close the path
        aPath.close()
        //If you want to stroke it with a red color
        UIColor.black.set()
        aPath.stroke()
        //If you want to fill it as well
        aPath.fill()
    }
    
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */

}
