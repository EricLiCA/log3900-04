//
//  ClassDiagramView.swift
//  poly-paint-ios
//
//  Created by Tomato on 2018-11-04.
//  Copyright © 2018 PolyAcme. All rights reserved.
//

import UIKit

class ClassDiagramView: BasicShapeView {
    let lineWidth: CGFloat = 1
    var lastRotation: CGFloat = 0
    var originalRotation = CGFloat()
    let defaultTextLineHeight: CGFloat = 40
    let defaultMaxNumOfLines = 5
    let textGap: CGFloat = 5
    var text = [String]()

    
    init(text: [String]) {
        let rectangle = CGRect(x: 100, y: 100, width: 200, height: 300)
        let dumpLayer = CALayer()
        super.init(frame: rectangle, layer: dumpLayer, numberOfAnchorPoints: 4)
        initGestureRecognizers()
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
        var anchorPoints = [topAnchorPoint, rightAnchorPoint, bottomAnchorPoint, leftAnchorPoint]
        
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
            // draw ligne
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
        // Send notification to update username label in ProfileViewController
        let userInfo = [ "text" : rawText.text! ]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "createClassDiagramAlert"), object: nil, userInfo: userInfo)
    }
    
}
