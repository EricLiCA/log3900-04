//
//  StickFigureView.swift
//  poly-paint-ios
//
//  Created by Tomato on 2018-11-04.
//  Copyright © 2018 PolyAcme. All rights reserved.
//

import UIKit

public class StickFigureView: BasicShapeView {

    let defaultHeight: CGFloat = 100
    let defaultWidth: CGFloat = 80
    var actorName = ""
    
    init(actorName: String, x: CGFloat, y: CGFloat, height: CGFloat, width: CGFloat, index: Int) {
        let frame = CGRect(x: x, y: y, width: self.defaultWidth, height: self.defaultHeight)
        self.actorName = actorName
        super.init(frame: frame, numberOfAnchorPoints: 4, color: UIColor.white, shapeType: "ACTOR", index: index)
        let image = UIImage(named: "StickFigure")
        //image?.draw(in: frame)
        //image?.size.height = self.defaultHeight
        //image?.size.width = self.defaultWidth
        self.backgroundColor = UIColor(patternImage: image!)
        
    }
    
    // We need to implement init(coder) to avoid compilation errors
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func draw(_ rect: CGRect) {
        
        self.initializeAnchorPoints()
        self.addActorName()
    }
    
    func addActorName() {
        let label = UILabel()
        label.frame = CGRect(x: 0 , y: self.defaultHeight, width: self.bounds.width + 10, height: self.bounds.height)
        label.text = self.actorName
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 10
        label.textAlignment = NSTextAlignment.center
        label.textColor = UIColor.black
        label.font = UIFont(name: "Helvetica", size: 14)
        self.addSubview(label)
    }
    
    func initializeAnchorPoints() {
        let topAnchorPoint = CGPoint(x: self.frame.size.width/2, y: 0)
        let rightAnchorPoint = CGPoint(x: self.frame.size.width, y: self.frame.size.height/2)
        let bottomAnchorPoint = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height)
        let leftAnchorPoint = CGPoint(x: 0, y: self.frame.size.height/2)
        var anchorPoints = [rightAnchorPoint, bottomAnchorPoint, leftAnchorPoint, topAnchorPoint]
        
        for anchor in anchorPoints {
            var circlePath = UIBezierPath(arcCenter: anchor, radius: CGFloat(15), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
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
    
    override func toShapeObject() -> Data? {
        
        let shape: [String: Any] = [
            
            "Id": self.uuid,
            "ImageId": "9db006f6-cd93-11e8-ad4f-12e4abeee048",
            "ShapeType": self.shapeType!,
            "Index": self.index,
            "ShapeInfo": [
                "Content": [self.actorName],
                "Center": [
                    "X": self.frame.origin.x,
                    "Y": self.frame.origin.y
                ],
                "Width": self.frame.width,
                "Height": self.frame.height,
                "Color": "#FF000000"
            ]
        ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: shape, options: .prettyPrinted)
        return jsonData;
        
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
