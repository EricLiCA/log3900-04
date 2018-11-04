//
//  DrawViewController.swift
//  poly-paint-ios
//
//  Created by Tomato on 2018-10-25.
//  Copyright © 2018 PolyAcme. All rights reserved.
//

import UIKit

enum Shape {
    case Rectangle
    case Ellipse
    case Triangle
    case None
}

class DrawViewController: UIViewController {

    @IBOutlet weak var drawingPlace: UIView!
    @IBOutlet weak var triangleButton: UIButton!
    @IBOutlet weak var ellipseButton: UIButton!
    @IBOutlet weak var rectangleButton: UIButton!
    
    var startTouch : CGPoint?
    var secondTouch : CGPoint?
    var currentContext : CGContext?
    var prevImage : UIImage?
    var lines = [Line]()
    var currentLineStartPoint: CGPoint?
    var currentLineEndPoint: CGPoint?
    var currentShape = Shape.None
    var isUserEditing: Bool = false
    var path = [UIBezierPath]()
    var currentBezierPath: UIBezierPath?
    var goodLayer = [CALayer]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(didTap(tapGR:)))
        self.view.addGestureRecognizer(tapGR)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func didTap(tapGR: UITapGestureRecognizer) {
        print("DIDTAPPPP")
    }
    
    
    @IBAction func rectangleTapped(_ sender: UIButton) {
        if(self.currentShape == Shape.Rectangle) {
            self.isUserEditing = false
            self.rectangleButton.backgroundColor = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
            self.currentShape = Shape.None
        } else {
            self.isUserEditing = true
            self.currentShape = Shape.Rectangle
            self.rectangleButton.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            self.ellipseButton.backgroundColor = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
            self.triangleButton.backgroundColor = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
        }
    }
    
    @IBAction func ellipseTapped(_ sender: UIButton) {
        if(self.currentShape == Shape.Ellipse) {
            self.isUserEditing = false
            self.ellipseButton.backgroundColor = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
            self.currentShape = Shape.None
        } else {
            self.isUserEditing = true
            self.currentShape = Shape.Ellipse
            self.ellipseButton.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            self.rectangleButton.backgroundColor = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
            self.triangleButton.backgroundColor = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
        }
    }
    
    @IBAction func triangleTapped(_ sender: UIButton) {
        if(self.currentShape == Shape.Triangle) {
            self.isUserEditing = false
            self.triangleButton.backgroundColor = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
            self.currentShape = Shape.None
        } else {
            self.isUserEditing = true
            self.currentShape = Shape.Triangle
            self.triangleButton.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            self.ellipseButton.backgroundColor = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
            self.rectangleButton.backgroundColor = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        startTouch = touch?.location(in: drawingPlace)
        self.currentLineStartPoint = startTouch
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(isUserEditing) {
            
            // erase sublayers used for drawing
            if(self.drawingPlace.layer.sublayers != nil) {
                for layer in self.drawingPlace.layer.sublayers! {
                    self.drawingPlace.layer.sublayers?.popLast()
                }
                for layer in self.goodLayer {
                    self.drawingPlace.layer.addSublayer(layer)
                }
            }
            
            for touch in touches{
                secondTouch = touch.location(in: drawingPlace)
                
                if(self.currentContext == nil) {
                    UIGraphicsBeginImageContext(drawingPlace.frame.size)
                    self.currentContext = UIGraphicsGetCurrentContext()
                } else {
                    self.currentContext?.clear(CGRect(x: 0, y: 0, width: drawingPlace.frame.width, height: drawingPlace.frame.height))
                }
                
                var bezier = UIBezierPath()
                switch self.currentShape {
                case .Rectangle:
                    bezier = self.drawRectangle(startPoint: startTouch!, secondPoint: secondTouch!)
                case .Ellipse:
                    bezier = self.drawEllipse(startPoint: startTouch!, secondPoint: secondTouch!)
                case .Triangle:
                    bezier = self.drawTriangle(startPoint: startTouch!, secondPoint: secondTouch!)
                case .None:
                    print("nothing")
                }
                
                UIColor.gray.set()
                self.currentContext?.setLineWidth(1)
                self.currentBezierPath = bezier
                self.currentContext?.addPath(bezier.cgPath)
                self.currentContext?.strokePath()

                let shape = CAShapeLayer()
                shape.frame = (self.drawingPlace.bounds)
                shape.path = self.currentBezierPath?.cgPath;
                shape.strokeColor = UIColor.black.cgColor
                shape.borderColor = UIColor.gray.cgColor
                self.drawingPlace.layer.addSublayer(shape)
                self.currentContext?.addPath((self.currentBezierPath?.cgPath)!)
            }
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(isUserEditing) {
            for touch in touches {
                print("touch ended")
            }
            
            let touch = touches.first
            self.currentLineEndPoint = touch?.location(in: drawingPlace)
            self.currentContext = nil
            self.currentBezierPath?.close()
            self.path.append(currentBezierPath!)
            self.addToLines()
            let myLayer = CAShapeLayer()
            myLayer.path = self.currentBezierPath?.cgPath
            myLayer.borderWidth = 2
            myLayer.strokeColor = UIColor.black.cgColor
            
            if(currentShape == Shape.Rectangle) {
                let rectangleView = RectangleView(frame: (self.currentBezierPath?.bounds)!, layer: myLayer)
                self.drawingPlace.addSubview(rectangleView)
            } else if(currentShape == Shape.Ellipse) {
                let ellipseView = EllipseView(frame: (self.currentBezierPath?.bounds)!, layer: myLayer)
                self.drawingPlace.addSubview(ellipseView)
            } else if(currentShape == Shape.Triangle) {
                let triangleView = TriangleView(frame: (self.currentBezierPath?.bounds)!, layer: myLayer)
                self.drawingPlace.addSubview(triangleView)
            }
            
            self.goodLayer.append((self.drawingPlace.layer.sublayers?.popLast())!)
            for layer in self.drawingPlace.layer.sublayers! {
                self.drawingPlace.layer.sublayers?.popLast()
            }
            for layer in self.goodLayer {
                self.drawingPlace.layer.addSublayer(layer)
            }
        }
        
    }
    
    func addToLines() {
        lines.append(Line(start: self.currentLineStartPoint!, end: self.currentLineEndPoint!))
    }
    
    func drawRectangle(startPoint: CGPoint, secondPoint: CGPoint) -> UIBezierPath {
        let bezier = UIBezierPath()
        bezier.move(to: startPoint)
        bezier.addLine(to: CGPoint(x: (secondPoint.x), y: (startPoint.y)))
        var currentTouch = CGPoint(x: (secondPoint.x), y: (startPoint.y))
        bezier.move(to:currentTouch)
        bezier.addLine(to: CGPoint(x: (secondPoint.x), y: (secondPoint.y)))
        bezier.move(to:secondTouch!)
        bezier.addLine(to: CGPoint(x: (startPoint.x), y: (secondPoint.y)))
        bezier.move(to:CGPoint(x: (startPoint.x), y: (secondPoint.y)))
        bezier.addLine(to: CGPoint(x: (startPoint.x), y: (startPoint.y)))
        
        // For rectangle
        
        
        bezier.close()
        
        return bezier
    }
    
    func drawEllipse(startPoint: CGPoint, secondPoint: CGPoint) -> UIBezierPath {
        let bezier = UIBezierPath(ovalIn: CGRect(x: startPoint.x, y: startPoint.y, width:secondPoint.x - startPoint.x, height: secondPoint.y - startPoint.y))
        
        bezier.close()
        
        return bezier
    }
    
    func drawCircle(startPoint: CGPoint, secondPoint: CGPoint) -> UIBezierPath {
        let bezier = UIBezierPath(ovalIn: CGRect(x: startPoint.x, y: startPoint.y, width:secondPoint.y - startPoint.y, height: secondPoint.y - startPoint.y))
        
        bezier.close()
        
        return bezier
    }
    
    func drawTriangle(startPoint: CGPoint, secondPoint: CGPoint) -> UIBezierPath {
        let bezier = UIBezierPath()
        let xPoint: CGFloat = (secondPoint.x - startPoint.x)*0.5 + startPoint.x
        let yPoint: CGFloat = (secondPoint.y - startPoint.y)*0.5 + startPoint.y
        let topCorner = CGPoint(x: xPoint, y: yPoint)
        bezier.move(to: topCorner)
        bezier.addLine(to: CGPoint(x: (secondPoint.x), y: (secondPoint.y)))
        bezier.move(to:secondPoint)
        let leftCorner = CGPoint(x: startPoint.x, y: secondPoint.y)
        bezier.addLine(to: leftCorner)
        bezier.move(to:leftCorner)
        bezier.addLine(to: topCorner)
        
        return bezier
    }
    
    func distance(_ a: CGPoint, _ b: CGPoint) -> CGFloat {
        let xDist = a.x - b.x
        let yDist = a.y - b.y
        return CGFloat(sqrt(xDist * xDist + yDist * yDist))
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

