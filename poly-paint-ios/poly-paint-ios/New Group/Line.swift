//
//  Line.swift
//  poly-paint-ios
//
//  Created by Tomato on 2018-11-13.
//  Copyright © 2018 PolyAcme. All rights reserved.
//

import Foundation
import UIKit

public enum Relation: String {
    case Composition = "COMPOSITION"
    case Association = "ASSOCIATION"
    case Aggregation = "AGGREGATION"
    case Inheritance = "INHERITANCE"
    case Arrow = "ARROW"
}

public class Line: Equatable {
    
    var layer: CAShapeLayer?
    var points = [CGPoint]()
    var firstAnchorShapeId: String?
    var firstAnchorShapeIndex: Int?
    var secondAnchorShapeId: String?
    var secondAnchorShapeIndex: Int?
    var firstEndLabel: String?
    var firstEndRelation: Relation?
    var secondEndLabel: String?
    var secondEndRelation: Relation?
    var selected = false
    var hitStartPoint: Int?
    var hitEndPoint: Int?
    var relationAngle = CGFloat(Double.pi / 6)
    var uuid = NSUUID.init().uuidString.lowercased()
    
    public init(layer: CAShapeLayer, startPoint: CGPoint, endPoint: CGPoint, firstEndRelation: Relation, secondEndRelation: Relation, firstEndTextField: String, secondEndTextField: String) {
        self.points.append(startPoint)
        self.points.append(endPoint)
        self.layer = layer
        self.firstEndRelation = firstEndRelation
        self.secondEndRelation = secondEndRelation
        self.redrawLine()
        self.firstEndLabel = firstEndTextField
        self.secondEndLabel = secondEndTextField
    }
    
    func hitTest(touchPoint: CGPoint) -> Bool {

        for (index, point) in self.points.enumerated() {
            if(index != (self.points.count - 1)) {
                var distanceToSegment = findDistanceToSegment(touchPoint: touchPoint, p1: self.points[index], p2: self.points[index + 1])

                if(distanceToSegment > 15) {

                } else if(distanceToSegment < 15) {
                    self.hitStartPoint = index
                    self.hitEndPoint = index + 1
                    self.select()
                    return true
                }
            }
        }
        self.unselect()
        return false
    }
    
    func hitPointTest(touchPoint: CGPoint) -> Int {
        var index = 0
        for point in self.points {
            var distanceToPoint = self.findDistanceBetween(p1: touchPoint, p2: point)
            if(distanceToPoint < 10) {
                print("TOUCHED POINT!!")
                self.select()
                return index
            } else {

            }
            
            index = index + 1
        }
        self.unselect()
        return -1
    }
    
    func findDistanceToSegment(touchPoint: CGPoint, p1: CGPoint, p2: CGPoint) -> CGFloat {
        
        var dx = p2.x - p1.x
        var dy = p2.y - p1.y
        
        if((dx == 0) && (dy == 0)) {
            dx = touchPoint.x - p1.x
            dy = touchPoint.y - p1.y
        }
        
        var t = ((touchPoint.x - p1.x)*dx + (touchPoint.y - p1.y)*dy) / (dx * dx + dy * dy)
        
        if(t < 0) {
            var closest = CGPoint(x: p1.x, y: p2.y)
            dx = touchPoint.x - p1.x
            dy = touchPoint.y - p1.y
        } else if(t > 1) {
            var closest = CGPoint(x: p2.x, y: p2.y)
            dx = touchPoint.x - p2.x
            dy = touchPoint.y - p2.y
        } else {
            var closest = CGPoint(x: p1.x + t*dx, y: p1.y + t*dy)
            dx = touchPoint.x - closest.x
            dy = touchPoint.y - closest.y
        }
        
        return sqrt(dx*dx + dy*dy)
        
    }
    
    func findDistanceBetween(p1: CGPoint, p2: CGPoint) -> CGFloat {
        let dx = p1.x - p2.x
        let dy = p1.y - p2.y
        return sqrt(dx*dx + dy*dy)
    }
    
    func addPoint(point: CGPoint) {
        self.points.insert(point, at: self.hitStartPoint! + 1)
        self.hitEndPoint = self.hitEndPoint! + 1
    }
    
    func unselect() {
        self.hitStartPoint = nil
        self.hitEndPoint = nil
        self.selected = false
        self.layer?.strokeColor = UIColor.black.cgColor
    }
    
    func select() {
        self.selected = true
        self.layer?.strokeColor = UIColor.green.cgColor
        
        
    }

    
    func redrawLine() {
        var bezier = UIBezierPath()

        for (index, point) in self.points.enumerated() {
            if(index < self.points.count - 1) {
                bezier.move(to: self.points[index])
                bezier.addLine(to: self.points[index + 1])
            }
        }
        
        if(self.firstEndRelation == Relation.Arrow) {
            self.addArrow(start: self.points[1], end: self.points[0], pointerLineLength: 20, arrowAngle: self.relationAngle, bezier: bezier)
        }
        if(self.secondEndRelation == Relation.Arrow) {
            self.addArrow(start: self.points[self.points.count - 2], end: self.points[self.points.count - 1], pointerLineLength: 20, arrowAngle: self.relationAngle, bezier: bezier)
        }
        if(self.firstEndRelation == Relation.Inheritance) {
            self.addInheritance(start: self.points[1], end: self.points[0], pointerLineLength: 20, arrowAngle: self.relationAngle, bezier: bezier)
        }
        if(self.secondEndRelation == Relation.Inheritance) {
            self.addInheritance(start: self.points[self.points.count - 2], end: self.points[self.points.count - 1], pointerLineLength: 20, arrowAngle: self.relationAngle, bezier: bezier)
        }
        if(self.firstEndRelation == Relation.Aggregation) {
            self.addAggregationComposition(start: self.points[1], end: self.points[0], pointerLineLength: 20, arrowAngle: self.relationAngle, bezier: bezier, relation: Relation.Aggregation)
        }
        if(self.secondEndRelation == Relation.Aggregation) {
            self.addAggregationComposition(start: self.points[self.points.count - 2], end: self.points[self.points.count - 1], pointerLineLength: 20, arrowAngle: self.relationAngle, bezier: bezier, relation: Relation.Aggregation)
        }
        if(self.firstEndRelation == Relation.Composition) {
            self.addAggregationComposition(start: self.points[1], end: self.points[0], pointerLineLength: 20, arrowAngle: self.relationAngle, bezier: bezier, relation: Relation.Composition)
        }
        if(self.secondEndRelation == Relation.Composition) {
            self.addAggregationComposition(start: self.points[self.points.count - 2], end: self.points[self.points.count - 1], pointerLineLength: 20, arrowAngle: self.relationAngle, bezier: bezier, relation: Relation.Composition)
        }
        
        
        let layer = CAShapeLayer()
        layer.path = bezier.cgPath
        layer.borderWidth = 2
        layer.strokeColor = UIColor.black.cgColor
        self.layer = layer
        self.select()
    }
    
    func addArrow(start: CGPoint, end: CGPoint, pointerLineLength: CGFloat, arrowAngle: CGFloat, bezier: UIBezierPath) {
        
        let startEndAngle = atan((end.y - start.y) / (end.x - start.x)) + ((end.x - start.x) < 0 ? CGFloat(Double.pi) : 0)
        let arrowLine1 = CGPoint(x: end.x + pointerLineLength * cos(CGFloat(Double.pi) - startEndAngle + arrowAngle), y: end.y - pointerLineLength * sin(CGFloat(Double.pi) - startEndAngle + arrowAngle))
        let arrowLine2 = CGPoint(x: end.x + pointerLineLength * cos(CGFloat(Double.pi) - startEndAngle - arrowAngle), y: end.y - pointerLineLength * sin(CGFloat(Double.pi) - startEndAngle - arrowAngle))
        bezier.move(to: end)
        bezier.addLine(to: arrowLine1)
        bezier.move(to: end)
        bezier.addLine(to: arrowLine2)
        bezier.close()
    }
    
    func addInheritance(start: CGPoint, end: CGPoint, pointerLineLength: CGFloat, arrowAngle: CGFloat, bezier: UIBezierPath) {
        let startEndAngle = atan((end.y - start.y) / (end.x - start.x)) + ((end.x - start.x) < 0 ? CGFloat(Double.pi) : 0)
        let arrowLine1 = CGPoint(x: end.x + pointerLineLength * cos(CGFloat(Double.pi) - startEndAngle + arrowAngle), y: end.y - pointerLineLength * sin(CGFloat(Double.pi) - startEndAngle + arrowAngle))
        let arrowLine2 = CGPoint(x: end.x + pointerLineLength * cos(CGFloat(Double.pi) - startEndAngle - arrowAngle), y: end.y - pointerLineLength * sin(CGFloat(Double.pi) - startEndAngle - arrowAngle))
        bezier.move(to: end)
        bezier.addLine(to: arrowLine1)
        bezier.move(to: end)
        bezier.addLine(to: arrowLine2)
        bezier.move(to: arrowLine2)
        bezier.addLine(to: arrowLine1)
        bezier.close()
        UIColor.white.setFill()
        bezier.fill()
    }
    
    func addAggregationComposition(start: CGPoint, end: CGPoint, pointerLineLength: CGFloat, arrowAngle: CGFloat, bezier: UIBezierPath, relation: Relation) {
        let startEndAngle = atan((end.y - start.y) / (end.x - start.x)) + ((end.x - start.x) < 0 ? CGFloat(Double.pi) : 0)
        let arrowLine1 = CGPoint(x: end.x + pointerLineLength * cos(CGFloat(Double.pi) - startEndAngle + arrowAngle), y: end.y - pointerLineLength * sin(CGFloat(Double.pi) - startEndAngle + arrowAngle))
        let arrowLine2 = CGPoint(x: end.x + pointerLineLength * cos(CGFloat(Double.pi) - startEndAngle - arrowAngle), y: end.y - pointerLineLength * sin(CGFloat(Double.pi) - startEndAngle - arrowAngle))
        let average = CGPoint(x: (arrowLine1.x + arrowLine2.x)/2, y:(arrowLine1.y + arrowLine2.y)/2)
        let difference = CGPoint(x: average.x - end.x, y: average.y - end.y)
        let otherPoint = CGPoint(x: end.x + 2*difference.x, y: end.y + 2*difference.y)

        if(relation == Relation.Composition) {
            bezier.move(to: end)
            bezier.addLine(to: arrowLine1)
            bezier.addLine(to: arrowLine2)
            bezier.move(to: otherPoint)
            bezier.addLine(to: arrowLine1)
            bezier.addLine(to: arrowLine2)
            bezier.close()
        } else {
            bezier.move(to: end)
            bezier.addLine(to: arrowLine1)
            bezier.move(to: arrowLine1)
            bezier.addLine(to: otherPoint)
            bezier.move(to: otherPoint)
            bezier.addLine(to: arrowLine2)
            bezier.move(to: arrowLine2)
            bezier.addLine(to: end)
        }

        
    }
    
    func addLabels() -> [UILabel] {
        // firstEndLabel
        let firstEndLocation = self.getLabelPosition(p1: self.points[0], p2: self.points[1], labelWidth: 50, isAnchoredOnSide: true)
        let firstEndLabel = UILabel()
        firstEndLabel.frame = CGRect(x: firstEndLocation.x , y: firstEndLocation.y, width: 50, height: 30)
        firstEndLabel.text = self.firstEndLabel
        firstEndLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        firstEndLabel.numberOfLines = 10
        firstEndLabel.textAlignment = NSTextAlignment.center
        firstEndLabel.textColor = UIColor.black
        firstEndLabel.font = UIFont(name: "Helvetica", size: 14)
        
        // secondEndLabel
        let secondEndLocation = self.getLabelPosition(p1: self.points[self.points.count - 1], p2: self.points[self.points.count - 2], labelWidth: 50, isAnchoredOnSide: true)
        let secondEndLabel = UILabel()
        secondEndLabel.frame = CGRect(x: secondEndLocation.x , y: secondEndLocation.y, width: 50, height: 30)
        secondEndLabel.text = self.secondEndLabel
        secondEndLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        secondEndLabel.numberOfLines = 10
        secondEndLabel.textAlignment = NSTextAlignment.center
        secondEndLabel.textColor = UIColor.black
        secondEndLabel.font = UIFont(name: "Helvetica", size: 14)
        
        return [firstEndLabel, secondEndLabel]
    }
    
    func getLabelPosition(p1: CGPoint, p2: CGPoint, labelWidth: CGFloat, isAnchoredOnSide: Bool) -> CGPoint {
    
        var x: CGFloat;
        if (p1.x < p2.x && isAnchoredOnSide || p1.x > p2.x && !isAnchoredOnSide) {
            x = p1.x + 10
        } else {
            x = p1.x - labelWidth - 10
        }
        
        var y: CGFloat;
        if (p1.y > p2.y && isAnchoredOnSide || p1.y < p2.y && !isAnchoredOnSide) {
            y = p1.y
        } else {
            y = p1.y - 25
        }
        
        return CGPoint(x: x, y: y);
    }
    
    static public func == (lhs: Line, rhs: Line) -> Bool{
        return lhs.uuid == rhs.uuid
    }
    
    func toShapeObject() -> Data? {
        var pointsArray = [Any]()
        for point in self.points {
            pointsArray.append(["X": point.x, "Y": point.y])
        }

        let shape: [String: Any] = [
            "Id": self.uuid,
            "ImageId": "9db006f6-cd93-11e8-ad4f-12e4abeee048",
            "ShapeType": "LINE",
            "Index": 1,
            "ShapeInfo": [
                "Points": pointsArray,
                "FirstAnchorId": self.firstAnchorShapeId,
                "FirstAnchorIndex": self.firstAnchorShapeIndex,
                "SecondAnchorId": self.secondAnchorShapeId,
                "SecondAnchorIndex": self.secondAnchorShapeIndex,
                "FirstEndLabel": self.firstEndLabel,
                "SecondEndLabel": self.secondEndLabel,
                "FirstEndRelation": self.firstEndRelation?.rawValue,
                "SecondEndRelation": self.secondEndRelation?.rawValue
            ]
        ]
        
        
        let jsonData = try? JSONSerialization.data(withJSONObject: shape, options: .prettyPrinted)
        return jsonData
    }
}
