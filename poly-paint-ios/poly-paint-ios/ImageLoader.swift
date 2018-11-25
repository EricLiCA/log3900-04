//
//  ImageLoader.swift
//  poly-paint-ios
//
//  Created by JP Cech on 11/15/18.
//  Copyright © 2018 PolyAcme. All rights reserved.
//

//
//  ImageLoader.swift
//
//
//  Created by JP Cech on 11/16/18.
//

import Foundation
import UIKit

public struct ImageLoader {
    
    public func buildFrame(shape: [String: AnyObject], type: String) -> CGRect?{
        
        switch type {
            
        case "RECTANGLE" :
            let center = shape["ShapeInfo"]?["Center"] as! [String: AnyObject]
            return CGRect(origin: CGPoint(x: center["X"] as! Double , y: center["Y"] as! Double), size: CGSize(width: shape["ShapeInfo"]?["Width"] as! Double, height: shape["ShapeInfo"]?["Height"] as! Double))
            
        case "ELLIPSE" :
            let center = shape["ShapeInfo"]?["Center"] as! [String: AnyObject]
            let path = UIBezierPath(ovalIn: CGRect(x: center["X"] as! Double, y: center["Y"] as! Double, width:shape["ShapeInfo"]?["Width"] as! Double, height:shape["ShapeInfo"]?["Height"] as! Double))
            path.close()
            return path.bounds
            
        case "TRIANGLE" :
            let center = shape["ShapeInfo"]?["Center"] as! [String: AnyObject]
            let path = UIBezierPath()
            path.move(to: CGPoint(x: center["X"] as! Double, y: center["Y"] as! Double - (shape["ShapeInfo"]?["Height"] as! Double)/2 ))
            path.addLine(to: CGPoint(x: center["X"] as! Double - (shape["ShapeInfo"]?["Width"] as! Double)/2, y: center["Y"] as! Double + (shape["ShapeInfo"]?["Height"] as! Double)/2))
            path.addLine(to: CGPoint(x: center["X"] as! Double + (shape["ShapeInfo"]?["Width"] as! Double)/2, y: center["Y"] as! Double + (shape["ShapeInfo"]?["Height"] as! Double)/2))
            path.close()
            return path.bounds
            
        default:
            print("error in loading image frame")
            return nil;
        }
        
    }
    
    public func parseClass(shape: [String: AnyObject]) -> ClassDiagramView? {
        let center = shape["ShapeInfo"]?["Center"] as! [String: AnyObject]
        return ClassDiagramView(text: shape["ShapeInfo"]?["Content"] as! [String], x: center["X"] as! CGFloat, y: center["Y"] as! CGFloat, height: shape["ShapeInfo"]?["Height"] as! CGFloat, width:shape["ShapeInfo"]?["Width"] as! CGFloat, index: shape["Index"] as! Int )
        
    }
    
    public func parseActor(shape: [String: AnyObject]) -> StickFigureView? {
        let center = shape["ShapeInfo"]?["Center"] as! [String: AnyObject]
        let actorName = shape["ShapeInfo"]?["Content"] as! [String]
        return StickFigureView(actorName: actorName[0], x: center["X"] as! CGFloat, y: center["Y"] as! CGFloat, height: shape["ShapeInfo"]?["Height"] as! CGFloat, width:shape["ShapeInfo"]?["Width"] as! CGFloat, index: shape["Index"] as! Int )
    }
    
    /*public func parseLine(shape: [String: AnyObject]) -> Line? {
        return Line(layer: <#T##CAShapeLayer#>, startPoint: <#T##CGPoint#>, endPoint: <#T##CGPoint#>, firstEndRelation: <#T##Relation#>, secondEndRelation: <#T##Relation#>, firstEndTextField: <#T##String#>, secondEndTextField: <#T##String#>)
    }*/
    
    public func parseShapes(shape: [String: AnyObject]) ->BasicShapeView? {
        
        let type = shape["ShapeType"] as? String
        print(type!)
        switch type! {
        case "RECTANGLE" :
            return RectangleView(frame: self.buildFrame(shape: shape, type: type!)!, color: UIColor(hexString: shape["ShapeInfo"]?["Color"] as! String), index: shape["Index"] as! Int)
            
        case "ELLIPSE" :
            return EllipseView(frame: self.buildFrame(shape: shape, type: type!)!, color: UIColor(hexString: shape["ShapeInfo"]?["Color"] as! String), useCase: "", index: shape["Index"] as! Int)
        case "TRIANGLE" :
            return TriangleView(frame: self.buildFrame(shape: shape, type: type!)!, color: UIColor(hexString: shape["ShapeInfo"]?["Color"] as! String), index: shape["Index"] as! Int)
            
        default:
            print("error in loading image frame")
            return nil;
        }
    }
    
}

