//
//  BasicShapeView.swift
//  poly-paint-ios
//
//  Created by Tomato on 2018-11-14.
//  Copyright © 2018 PolyAcme. All rights reserved.
//

import UIKit

public class BasicShapeView: UIView {

    let lineWidth: CGFloat = 1
    var touchAnchorPoint = false
    var uuid : String?
    var numberOfAnchorPoints: Int?
    var anchorPointsLayers = [CAShapeLayer]()
    var color: UIColor?
    var shapeType: String?
    var index: Int?
    var showAnchors = false
    var drawingSocketManager = DrawingSocketManager()
    
    init(frame: CGRect, numberOfAnchorPoints: Int, color:UIColor, shapeType: String?, index: Int) {
        self.shapeType = shapeType
        self.numberOfAnchorPoints = numberOfAnchorPoints - 1;
        super.init(frame: frame)
        self.initGestureRecognizers()
        self.backgroundColor = UIColor.blue
        self.setUpNotifications()
        self.color = color
        self.index = index
        self.uuid = NSUUID.init().uuidString.lowercased()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public var canBecomeFirstResponder: Bool {
        return true
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
    
    func setUpNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(lineDrawnAlert), name: NSNotification.Name(rawValue: "lineDrawnAlert"), object: nil)
        
    }
    
    @objc func lineDrawnAlert(sender: AnyObject) {
        for layer in self.anchorPointsLayers {
            layer.fillColor = UIColor.red.cgColor
            layer.strokeColor = UIColor.red.cgColor
        }
        self.touchAnchorPoint = false
    }
    
    @objc func didPan(panGR: UIPanGestureRecognizer) {
        if(!self.touchAnchorPoint) {
            self.superview!.bringSubview(toFront: self)
            var translation = panGR.translation(in: self)
            translation = translation.applying(self.transform)
            self.center.x += translation.x
            self.center.y += translation.y
            panGR.setTranslation(.zero, in: self)
            
            if(panGR.state == .ended) {
                //self.hideAnchorPoints()
                self.drawingSocketManager.editShape(shape: self)
            } else if(panGR.state == .began) {
                //self.showAnchorPoints()
            }
            
            let userInfo = ["shape": self] as [String : BasicShapeView]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "movedView"), object: nil, userInfo: userInfo)
        } else {
            //self.hideAnchorPoints()
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
    
    @objc func didLongPress(longPressGR: UILongPressGestureRecognizer) {
        self.showAnchorPoints()
        
        if(longPressGR.state == .cancelled) {
            self.hideAnchorPoints()
        }
        
        self.superview!.bringSubview(toFront: self)
        guard let gestureView = longPressGR.view, let superView = gestureView.superview else {
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
        if(self.shapeType == "USE") {
            let ellipseView = self as! EllipseView
            let shapeData = ["frame": self.frame, "layer": self.layer, "color": self.color!, "shapeType": self.shapeType!, "useCase": ellipseView.labelText!] as [String : Any]
            NotificationCenter.default.post(name: .duplicate, object: nil, userInfo: shapeData)
        } else if(self.shapeType == "ACTOR") {
            let stickFigureView = self as! StickFigureView
            let shapeData = ["shapeType": self.shapeType!, "actor": stickFigureView.actorName] as [String : Any]
            NotificationCenter.default.post(name: .duplicate, object: nil, userInfo: shapeData)
        } else if(self.shapeType == "CLASS") {
            let classDiagramView = self as! ClassDiagramView
            let shapeData = ["shapeType": classDiagramView.shapeType!, "text": classDiagramView.text, "x": classDiagramView.x, "y": classDiagramView.y, "height": classDiagramView.frame.height, "width": classDiagramView.frame.width] as [String : Any]
            NotificationCenter.default.post(name: .duplicate, object: nil, userInfo: shapeData)
        } else {
            let shapeData = ["frame": self.frame, "layer": self.layer, "color": self.color!, "shapeType": self.shapeType!] as [String : Any]
            NotificationCenter.default.post(name: .duplicate, object: nil, userInfo: shapeData)
        }
        
    }
    
    @objc internal func handleEditAction(_ controller: UIMenuController) {
    }
    
    @objc internal func handleDeleteAction(_ controller: UIMenuController) {
       // self.removeFromSuperview()
         let uuid = ["uuid": self.uuid] as [String : Any]
         NotificationCenter.default.post(name: .delete, object: nil, userInfo: uuid)
        
    }
        
    
    
    func showAnchorPoints() {
        for index in 0...self.numberOfAnchorPoints! {
            self.layer.sublayers![index].isHidden = false
        }
        
        self.showAnchors = true
    }
    
    func hideAnchorPoints() {
        for index in 0...self.numberOfAnchorPoints! {
            self.layer.sublayers![index].isHidden = true
            self.anchorPointsLayers[index].fillColor = UIColor.red.cgColor
            self.anchorPointsLayers[index].strokeColor = UIColor.red.cgColor
        }
        self.touchAnchorPoint = false
        self.showAnchors = false
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
    
    func getAnchorPoint(index: Int) -> CGPoint {
        return CGPoint(x: 0, y: 0)
    }
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        var numAnchor = 0
        for layer in self.anchorPointsLayers {
            let touchArea = CGRect(x: (touches.first?.location(in: self).x)!, y: (touches.first?.location(in: self).y)!, width: 50, height: 50)
            
            if (layer.path?.contains((touches.first?.location(in: self))!))! {
                // start drawing line
                if(self.touchAnchorPoint) {
                    layer.fillColor = UIColor.red.cgColor
                    layer.strokeColor = UIColor.red.cgColor
                    self.touchAnchorPoint = false
                } else {
                    layer.fillColor = UIColor.green.cgColor
                    layer.strokeColor = UIColor.green.cgColor
                    self.touchAnchorPoint = true
                    print("touched anchor")
                }
                
                let userInfo = ["view": self, "point" : touches.first?.location(in: self.superview), "anchorNumber": numAnchor] as [String : Any]
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "drawLineAlert"), object: nil, userInfo: userInfo)
            }
            numAnchor = numAnchor + 1
        }
    }
    
    func toShapeObject() -> Data? {
        let center = self.frame.origin
        let shape: [String: Any] = [
            "Id": self.uuid!,
            "ImageId": "9db006f6-cd93-11e8-ad4f-12e4abeee048",
            "ShapeType": self.shapeType!,
            "Index": self.index!,
            "ShapeInfo": [
                "Center": [
                    "X": self.frame.origin.x,
                    "Y": self.frame.origin.y
                ],
                "Width": self.frame.width,
                "Height": self.frame.height,
                "Color": self.color?.hexString
            ]
        ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: shape, options: .prettyPrinted)
        return jsonData;
        
    }
    
    func isOnAnchorPoint(touchPoint: CGPoint) -> Int {
        var numAnchor = 0
        for layer in self.anchorPointsLayers {
            let touchArea = CGRect(x: touchPoint.x, y: touchPoint.y, width: 50, height: 50)

            if (layer.path?.contains(touchPoint))! {
                layer.fillColor = UIColor.green.cgColor
                layer.strokeColor = UIColor.green.cgColor
                print("touched anchor")
                return numAnchor
            }
            numAnchor = numAnchor + 1
        }
        return -1
    }
}

extension Notification.Name {
    static let duplicate = Notification.Name("duplicate")
    static let delete = Notification.Name("delete")
}
