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
    var color: UIColor?
    var myframe: CGRect?
    var mylayer: CALayer?
    
    init(frame: CGRect, layer:CALayer, color: UIColor) {
        //super.init(frame:CGRect(x: 0.0, y: 0.0, width: defaultWidth, height: defaultHeight))
        //self.center = origin
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        initGestureRecognizers()
        self.color = color
        self.mylayer = layer
        self.myframe = frame
    }
    
    // We need to implement init(coder) to avoid compilation errors
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    func initGestureRecognizers() {
        let panGR = UIPanGestureRecognizer(target: self, action: #selector(didPan(panGR:)))
        addGestureRecognizer(panGR)
        let pinchGR = UIPinchGestureRecognizer(target: self, action: #selector(didPinch(pinchGR:)))
        addGestureRecognizer(pinchGR)
        let rotationGR = UIRotationGestureRecognizer(target: self, action: #selector(didRotate(rotationGR:)))
        addGestureRecognizer(rotationGR)
        let longPressGR = ( UILongPressGestureRecognizer( target: self, action: #selector(didLongPressed(_:))))
        addGestureRecognizer(longPressGR)
    }
    
    override func draw(_ rect: CGRect) {
        print("called draw")
        let insetRect = rect.insetBy(dx: lineWidth / 2, dy: lineWidth / 2)
        let path = self.trianglePathInRect(rect: insetRect)
        self.color?.setFill()
        path.fill()
        path.lineWidth = self.lineWidth
        self.color?.setStroke()
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
    
    @objc func didLongPressed(_ gesture: UILongPressGestureRecognizer) {
        self.superview!.bringSubview(toFront: self)
        guard let gestureView = gesture.view, let superView = gestureView.superview else {
            return
        }
        
        let menuController = UIMenuController.shared
        
        guard !menuController.isMenuVisible, gestureView.canBecomeFirstResponder else {
            return
        }
        gestureView.becomeFirstResponder()
        
        
        menuController.menuItems = [
            UIMenuItem(
                title: "Duplicate",
                action: #selector(handleDuplicateAction(_:))
            ),
            UIMenuItem(
                title: "Cut",
                action: #selector(handleCutAction(_:))
            ),
            UIMenuItem(
                title: "Edit",
                action: #selector(handleEditAction(_:))
            ),
            UIMenuItem(
                title: "Delete",
                action: #selector(handleDeleteAction(_:))
            )
        ]
        
        menuController.setTargetRect(gestureView.frame, in: superView)
        menuController.setMenuVisible(true, animated: true)
    }
    
    @objc internal func handleCutAction(_ controller: UIMenuController) {
    }
    
    @objc internal func handleDuplicateAction(_ controller: UIMenuController) {
        let shapeData = ["frame": self.myframe!, "layer": self.mylayer!, "color": self.color!] as [String : Any]
        NotificationCenter.default.post(name: .duplicateTriangle, object: nil, userInfo: shapeData)
    }
    
    @objc internal func handleEditAction(_ controller: UIMenuController) {
    }
    
    @objc internal func handleDeleteAction(_ controller: UIMenuController) {
        self.removeFromSuperview()
        
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
    
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}
extension Notification.Name {
    static let duplicateTriangle = Notification.Name("duplicateTriangle")
}
