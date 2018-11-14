//
//  TriangleView.swift
//  poly-paint-ios
//
//  Created by Tomato on 2018-10-30.
//  Copyright © 2018 PolyAcme. All rights reserved.
//

import UIKit

class TriangleView: UIView {

    let defaultHeight: CGFloat = 150.0
    let defaultWidth: CGFloat = 150.0
    let lineWidth: CGFloat = 1
    let uuid = NSUUID.init().uuidString.lowercased()
    var anchorPointsLayers = [CAShapeLayer]()
    var touchAnchorPoint = false
    
    init(frame: CGRect, layer:CALayer) {
        //super.init(frame:CGRect(x: 0.0, y: 0.0, width: defaultWidth, height: defaultHeight))
        //self.center = origin
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        initGestureRecognizers()
        self.setUpNotifications()
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
        let longPressGR = UILongPressGestureRecognizer(target: self, action: #selector(didLongPress(longPressGR:)))
        addGestureRecognizer(longPressGR)
    }
    
    override func draw(_ rect: CGRect) {
        print("called draw")
        let insetRect = rect.insetBy(dx: lineWidth / 2, dy: lineWidth / 2)
        let path = self.trianglePathInRect(rect: insetRect)
        UIColor.white.setFill()
        path.fill()
        path.lineWidth = self.lineWidth
        UIColor.black.setStroke()
        path.stroke()
        self.initializeAnchorPoints()
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
        
        let userInfo = ["view": self.uuid] as [String : String]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "movedView"), object: nil, userInfo: userInfo)
    }
    
    @objc func didLongPress(longPressGR: UILongPressGestureRecognizer) {
        self.showAnchorPoints()
        
        if(longPressGR.state == .cancelled) {
            self.hideAnchorPoints()
        }
    }
    
    func setUpNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(lineDrawnAlert), name: NSNotification.Name(rawValue: "lineDrawnAlert"), object: nil)
        
    }
    
    @objc func lineDrawnAlert(sender: AnyObject) {
        for layer in self.anchorPointsLayers {
            layer.fillColor = UIColor.red.cgColor
        }
        self.touchAnchorPoint = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //self.showAnchorPoints()
        print("called touches began")
        var numAnchor = 0
        for layer in self.anchorPointsLayers {
            let touchArea = CGRect(x: (touches.first?.location(in: self).x)!, y: (touches.first?.location(in: self).y)!, width: 50, height: 50)
            //print("TEXT: \(touchArea.contains((layer.path?.currentPoint)!))")
            //print("center: \(layer.path?.currentPoint)")
            //print("touch: \(touches.first?.location(in: self))")
            //layer.path?.currentPoint.
            //print(layer.path?.contains((touches.first?.location(in: self))!))
            
            if (layer.path?.contains((touches.first?.location(in: self))!))! {
                // start drawing line
                print("touched!")
                //layer.fillColor = UIColor.green as! CGColor
                layer.fillColor = UIColor.green.cgColor
                self.touchAnchorPoint = true
                //let userInfo = [ "point" : touches.first?.location(in: self.superview), "viewUUID": self.uuid ] as [String : Any]
                let userInfo = ["view": self, "point" : touches.first?.location(in: self.superview), "anchorNumber": numAnchor] as [String : Any]
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "drawLineAlert"), object: nil, userInfo: userInfo)
            }
            numAnchor = numAnchor + 1
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //self.hideAnchorPoints()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(self.touchAnchorPoint) {
            print("moving")
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

    
    func trianglePathInRect(rect:CGRect) -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: rect.width / 2.0, y: rect.origin.y))
        path.addLine(to: CGPoint(x: rect.width,y: rect.height))
        path.addLine(to: CGPoint(x: rect.origin.x, y: rect.height))
        path.close()
        
        return path
    }
    
    func initializeAnchorPoints() {
        let rightAnchorPoint = CGPoint(x: self.frame.size.width*0.75, y: self.frame.size.height/2)
        let bottomAnchorPoint = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height)
        let leftAnchorPoint = CGPoint(x: self.frame.size.width/4, y: self.frame.size.height/2)
        var anchorPoints = [rightAnchorPoint, bottomAnchorPoint, leftAnchorPoint]
        
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
        for index in 0...2 {
            self.layer.sublayers![index].isHidden = false
        }
    }
    
    func hideAnchorPoints() {
        for index in 0...2 {
            self.layer.sublayers![index].isHidden = true
        }
    }
    
    func getAnchorPoint(index: Int) -> CGPoint {
        if(index == 0) {
            let rightAnchorPoint = CGPoint(x: self.center.x + self.frame.size.width/2, y: self.center.y)
            return rightAnchorPoint
        } else if (index == 1) {
            let bottomAnchorPoint = CGPoint(x: self.center.x, y: self.center.y + self.frame.size.height/2)
            return bottomAnchorPoint
        } else if(index == 2) {
            let leftAnchorPoint = CGPoint(x: self.center.x - self.frame.size.width/2, y: self.center.y)
            return leftAnchorPoint
        } else { // garbage
            return CGPoint(x: 0, y: 0)
        }
    }
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}
