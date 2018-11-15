//
//  ClassDiagramView.swift
//  poly-paint-ios
//
//  Created by Tomato on 2018-11-04.
//  Copyright © 2018 PolyAcme. All rights reserved.
//

import UIKit

class ClassDiagramView: BasicShapeView {
    
    let defaultTextLineHeight: CGFloat = 40
    let defaultMaxNumOfLines = 5
    let textGap: CGFloat = 5
    var text = [String]()

    init(text: [String]) {
        let rectangle = CGRect(x: 100, y: 100, width: 200, height: 300)
        super.init(frame: rectangle, numberOfAnchorPoints: 4, color: UIColor.white, shapeType: "CLASS")
        self.initGestureRecognizers()
        self.backgroundColor = UIColor.blue
        self.text = text
    }
    
    // We need to implement init(coder) to avoid compilation errors
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        self.initializeTextFields(words: self.text)
    }
    
    func initializeAnchorPoints() {
        let topAnchorPoint = CGPoint(x: self.frame.size.width/2, y: 0)
        let rightAnchorPoint = CGPoint(x: self.frame.size.width, y: self.frame.size.height/2)
        let bottomAnchorPoint = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height)
        let leftAnchorPoint = CGPoint(x: 0, y: self.frame.size.height/2)
        var anchorPoints = [rightAnchorPoint, bottomAnchorPoint, leftAnchorPoint, topAnchorPoint]
        
        for anchor in anchorPoints {
            var circlePath = UIBezierPath(arcCenter: anchor, radius: CGFloat(7), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
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
    
    func initializeTextFields(words: [String]) {
        var currentHeight = CGFloat(0)
        for word in words {
            // draw line
            let fromPoint = CGPoint(x: 0, y: currentHeight)
            let toPoint = CGPoint(x: self.frame.width, y: currentHeight)
            self.drawLine(fromPoint: fromPoint, toPoint: toPoint)
            // set label
            let label = UILabel(frame: CGRect(x: self.textGap, y: currentHeight, width: self.frame.width - self.textGap, height: self.defaultTextLineHeight))
            label.contentMode = .scaleToFill
            label.numberOfLines = self.defaultMaxNumOfLines
            label.text = word
            label.lineBreakMode = NSLineBreakMode.byWordWrapping
            
            if(currentHeight == CGFloat(0)) {
                label.textAlignment = NSTextAlignment.center
            } else {
                label.sizeToFit()
            }
            
            currentHeight += label.frame.height
            self.addSubview(label)
        }
    }
    
    func drawLine(fromPoint: CGPoint, toPoint: CGPoint) {
        let aPath = UIBezierPath()
        aPath.move(to: fromPoint)
        aPath.addLine(to: toPoint)
        aPath.close()
        UIColor.black.set()
        aPath.stroke()
        aPath.fill()
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

class classDiagramPopoverView: UIView {
    
    @IBOutlet weak var rawText: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.rawText.text = "Class Name\n--\nAttributes\n--\nMethods"
    }
    
    @IBAction func addClassTapped(_ sender: UIButton) {
        self.sendCreateClassDiagramNotification()
        
    }
    
    func sendCreateClassDiagramNotification() {
        let userInfo = [ "text" : rawText.text! ]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "createClassDiagramAlert"), object: nil, userInfo: userInfo)
    }
    
}
