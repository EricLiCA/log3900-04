//
//  DrawViewController.swift
//  poly-paint-ios
//
//  Created by Tomato on 2018-10-25.
//  Copyright © 2018 PolyAcme. All rights reserved.
//

import UIKit

enum Shape {
    case Circle
    case Rectangle
    case Ellipse
    case Triangle
    case None
}

class DrawViewController: UIViewController {

    //@IBOutlet weak var drawingPlace: UIImageView!
    @IBOutlet weak var drawingPlace: UIView!
    @IBOutlet weak var triangleButton: UIButton!
    
    @IBOutlet weak var ellipseButton: UIButton!
    @IBOutlet weak var circleButton: UIButton!
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
            self.circleButton.backgroundColor = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
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
            self.circleButton.backgroundColor = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
            self.rectangleButton.backgroundColor = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
            self.triangleButton.backgroundColor = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
        }
    }
    
    @IBAction func circleTapped(_ sender: UIButton) {

        if(self.currentShape == Shape.Circle) {
            self.isUserEditing = false
            self.circleButton.backgroundColor = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
            self.currentShape = Shape.None
        } else {
            self.isUserEditing = true
            self.currentShape = Shape.Circle
            self.circleButton.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            self.ellipseButton.backgroundColor = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
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
            self.circleButton.backgroundColor = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("initial layer: \(self.drawingPlace.layer.sublayers)")
        print("touch began")
        let touch = touches.first
        startTouch = touch?.location(in: drawingPlace)
        //print(startTouch)
        self.currentLineStartPoint = startTouch
        if(!isUserEditing) {
            //self.subview
            //self.bringSubview(toFront: self.drawingPlace.hitTest(startTouch!, with: event))
            
            //print(self.currentContext?.path)
            /*if (self.currentContext?.path?.contains(startTouch!))! {
                print("HIT")
            }*/
            //print(self.path[0].cgPath.currentPoint)
            //self.currentContext = UIGraphicsGetCurrentContext()
            //print(self.path[0].cgPath.appl)
            //let modifiedPoint = CGPoint(x: self.path[0].cgPath.currentPoint.x, y: self.path[0].cgPath.currentPoint.y+1)
            //print("contain: \(self.path[0].contains(modifiedPoint))")
            //print("current: \(self.currentContext?.path?.contains(startTouch!))")
            //var touched = self.drawingPlace..hitTest((touches.anyObject() as UITouch).locationInView(self.view), withEvent: event)
            /*if touched is RDView {
                touched?.backgroundColor = UIColor.redColor()
            }*/
            
           //super.touchesBegan(touches, with: event)
        }
        
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(isUserEditing) {
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
                
                
                if(self.currentContext == nil)
                {
                    UIGraphicsBeginImageContext(drawingPlace.frame.size)
                    self.currentContext = UIGraphicsGetCurrentContext()
                }else{
                    self.currentContext?.clear(CGRect(x: 0, y: 0, width: drawingPlace.frame.width, height: drawingPlace.frame.height))
                }
                
                //self.prevImage?.draw(in: self.drawingPlace.bounds)
                var bezier = UIBezierPath()
                switch self.currentShape {
                case .Circle:
                    bezier = self.drawCircle(startPoint: startTouch!, secondPoint: secondTouch!)
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
                //UIColor.blue.set()
                self.currentContext?.setLineWidth(1)
                self.currentBezierPath = bezier
                self.currentContext?.addPath(bezier.cgPath)
                self.currentContext?.strokePath()
                
                
                //self.drawingPlace.layer.sublayers?.popLast()
                let shape = CAShapeLayer()
                //shape.fillColor = UIColor.black.cgColor
                shape.frame = (self.drawingPlace.bounds)
                shape.path = self.currentBezierPath?.cgPath;
                shape.strokeColor = UIColor.black.cgColor
                shape.fillColor = UIColor.white.cgColor
                shape.borderColor = UIColor.gray.cgColor
                //shape.fillColor = UIColor.black.cgColor
                //self.drawingPlace.layer.sublayers
                self.drawingPlace.layer.addSublayer(shape)
                self.currentContext?.addPath((self.currentBezierPath?.cgPath)!)
                //print(bezier.cgPath)
                //let img2 = self.currentContext?.makeImage()
                //self.drawingPlace.image = UIImage.init(cgImage: img2!)
                //self.currentContext.path?.contains(<#T##point: CGPoint##CGPoint#>)
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
            print(self.currentContext?.path)
            self.currentContext = nil
            print("bouding rectangle \(self.currentBezierPath?.bounds)")
            
            self.currentBezierPath?.close()
            self.path.append(currentBezierPath!)
            //self.prevImage = self.drawingPlace.image
            self.addToLines()
            print(currentBezierPath)
            //let view = RandomView(origin:(self.currentBezierPath?.bounds.origin)! ,rectangle: (self.currentBezierPath?.bounds)!, bezierPath: self.currentBezierPath!)
            //self.view.addSubview(view)/
            
            //for layer in self.drawingPlace.layer.sublayers! {
            //self.drawingPlace.layer.sublayers?.popLast()
            //}
            //self.drawingPlace.layer.sublayers?.popLast()
            let myLayer = CAShapeLayer()
            myLayer.path = self.currentBezierPath?.cgPath
            myLayer.borderWidth = 2
            myLayer.strokeColor = UIColor.black.cgColor
            //self.drawingPlace.layer.sublayers?.popLast()
            //self.drawingPlace.layer.addSublayer(myLayer)
            print("layer framL \(myLayer.frame)")
            
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
            
            print("subviews: \(self.drawingPlace.subviews)")
            self.goodLayer.append((self.drawingPlace.layer.sublayers?.popLast())!)
            for layer in self.drawingPlace.layer.sublayers! {
                self.drawingPlace.layer.sublayers?.popLast()
            }
            for layer in self.goodLayer {
                self.drawingPlace.layer.addSublayer(layer)
            }
            //self.drawingPlace.layoutSubviews()
            //self.view.layer.addSublayer(myLayer)
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

class RandomView: UIView {
    
    var bezierPath: UIBezierPath
    let lineWidth: CGFloat = 1
    
    init(origin: CGPoint, rectangle: CGRect, bezierPath: UIBezierPath) {
        self.bezierPath = bezierPath
        super.init(frame:rectangle)
        self.center = origin
        self.backgroundColor = UIColor.clear
        initGestureRecognizers()
        //self.transform = self.transform.rotated(by: .pi/6)
        //self.transform = self.transform.scaledBy(x: 1, y: 2)
    }
    
    // We need to implement init(coder) to avoid compilation errors
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initGestureRecognizers() {
        let panGR = UIPanGestureRecognizer(target: self, action: #selector(didPan(panGR:)))
        addGestureRecognizer(panGR)
        let pinchGR = UIPinchGestureRecognizer(target: self, action: #selector(didPinch(pinchGR:)))
        addGestureRecognizer(pinchGR)
        let rotationGR = UIRotationGestureRecognizer(target: self, action: #selector(didRotate(rotationGR:)))
        addGestureRecognizer(rotationGR)
    }
    
    override func draw(_ rect: CGRect) {
        print("draw rect")
        //let insetRect = rect.insetBy(dx: lineWidth / 2, dy: lineWidth / 2)
        let path = self.bezierPath
        UIColor.white.setFill()
        path.fill()
        path.lineWidth = self.lineWidth
        UIColor.black.setStroke()
        path.stroke()
        print("center\(self.center)")
    }
    
    @objc func didPan(panGR: UIPanGestureRecognizer) {
        print("didPan")
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
        //self.transform = CGAffineTransform(rotationAngle: rotation)
        self.transform = self.transform.rotated(by: rotation)
        rotationGR.rotation = 0.0
        
        /*if rotationGR.state == .began {
         rotationGR.rotation = self.lastRotation
         self.originalRotation = rotationGR.rotation
         } else if rotationGR.state == .changed {
         let newRotation = rotationGR.rotation + originalRotation
         rotationGR.view?.transform = CGAffineTransform(rotationAngle: newRotation)
         } else if rotationGR.state == .ended {
         lastRotation = rotationGR.rotation
         }*/
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
}
