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
            return CGRect(origin: CGPoint(x: center["X"] as! Double , y: center["Y"] as! Double), size: CGSize(width: shape["ShapeInfo"]?["Width"] as! Int, height: shape["ShapeInfo"]?["Height"] as! Int))
            
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
    
    public func parseShapes(shape: [String: AnyObject]) ->BasicShapeView? {
        
        let type = shape["ShapeType"] as? String
        print(type!)
        switch type! {
        case "RECTANGLE" :
            return RectangleView(frame: self.buildFrame(shape: shape, type: type!)!, color: UIColor(hexString: shape["ShapeInfo"]?["Color"] as! String))
            
        case "ELLIPSE" :
            return EllipseView(frame: self.buildFrame(shape: shape, type: type!)!, color: UIColor(hexString: shape["ShapeInfo"]?["Color"] as! String))
            
        case "TRIANGLE" :
            return TriangleView(frame: self.buildFrame(shape: shape, type: type!)!, color: UIColor(hexString: shape["ShapeInfo"]?["Color"] as! String))
            
        default:
            print("error in loading image frame")
            return nil;
        }
    }
    
}

