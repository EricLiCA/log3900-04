//
//  StickFigureView.swift
//  poly-paint-ios
//
//  Created by Tomato on 2018-11-04.
//  Copyright © 2018 PolyAcme. All rights reserved.
//

import UIKit

class StickFigureView: UIView {

    let defaultHeight: CGFloat = 60
    let defaultWidth: CGFloat = 50
    let uuid = NSUUID.init().uuidString.lowercased()
    var lastRotation: CGFloat = 0
    var originalRotation = CGFloat()
    var anchorPointsLayers = [CAShapeLayer]()
    
    init() {
        let frame = CGRect(x: 0, y: 0, width: self.defaultWidth, height: self.defaultHeight)
        super.init(frame: frame)
        initGestureRecognizers()
        let image = UIImage(named: "StickFigure")
        self.backgroundColor = UIColor(patternImage: image!)
    }
    
    // We need to implement init(coder) to avoid compilation errors
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initGestureRecognizers() {
        let panGR = UIPanGestureRecognizer(target: self, action: #selector(didPan(panGR:)))
        addGestureRecognizer(panGR)
    }
    
    override func draw(_ rect: CGRect) {
        
        self.initializeAnchorPoints()
    }
    
    @objc func didPan(panGR: UIPanGestureRecognizer) {
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
    
    func initializeAnchorPoints() {
        let rightAnchorPoint = CGPoint(x: self.frame.size.width, y: self.frame.size.height/2)
        let leftAnchorPoint = CGPoint(x: 0, y: self.frame.size.height/2)
        var anchorPoints = [rightAnchorPoint, leftAnchorPoint]
        
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
        for index in 0...1 {
            self.layer.sublayers![index].isHidden = false
        }
    }
    
    func hideAnchorPoints() {
        for index in 0...1 {
            self.layer.sublayers![index].isHidden = true
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
