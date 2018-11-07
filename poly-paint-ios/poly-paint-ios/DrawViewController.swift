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
    case Line
    case None
}

class DrawViewController: UIViewController {

    @IBOutlet weak var drawingPlace: UIView!
    @IBOutlet weak var triangleButton: UIButton!
    @IBOutlet weak var ellipseButton: UIButton!
    @IBOutlet weak var rectangleButton: UIButton!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var stickFigure: UIButton!
    @IBOutlet weak var classButton: UIButton!
    @IBOutlet weak var lineButton: UIButton!
    
    var firstTouch : CGPoint?
    var secondTouch : CGPoint?
    var currentContext : CGContext?
    var currentShape = Shape.None
    var isUserEditing: Bool = false
    var currentBezierPath: UIBezierPath?
    var layersFromShapes = [CALayer]()
    var insideCanvas = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.drawingPlace.clipsToBounds = true
        self.setUpNotifications()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func insertTapped(_ sender: UIBarButtonItem) {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let drawRectangleAction = UIAlertAction(title: "Rectangle", style: .default, handler: { (alert: UIAlertAction!) -> Void in
            //  insert Rectangle here
        })
        alertController.addAction(drawRectangleAction)
        
        
        let drawEllipseAction = UIAlertAction(title: "Ellipse", style: .default, handler: { (alert: UIAlertAction!) -> Void in
            //  insert ellipse here
        })
        alertController.addAction(drawEllipseAction)

        
        let drawTriangleAction = UIAlertAction(title: "Triangle", style: .default, handler: { (alert: UIAlertAction!) -> Void in
            //  insert triangle here
        })
        alertController.addAction(drawTriangleAction)
        

        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: { (alert: UIAlertAction!) -> Void in
        })
        alertController.addAction(cancelAction)
        
        
        
        if let popoverController = alertController.popoverPresentationController {
            popoverController.barButtonItem = sender
        }
        
        self.present(alertController, animated: true, completion: nil)

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
            self.lineButton.backgroundColor = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
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
            self.lineButton.backgroundColor = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
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
            self.lineButton.backgroundColor = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
        }
    }
    
    @IBAction func lineTapped(_ sender: UIButton) {
        if(self.currentShape == Shape.Line) {
            self.isUserEditing = false
            self.lineButton.backgroundColor = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
            self.currentShape = Shape.None
        } else {
            self.isUserEditing = true
            self.currentShape = Shape.Line
            self.lineButton.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            self.ellipseButton.backgroundColor = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
            self.rectangleButton.backgroundColor = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
            self.triangleButton.backgroundColor = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
        }
    }
    
    @IBAction func stickfigureTapped(_ sender: UIButton) {
        let stickFigure = StickFigureView()
        self.drawingPlace.addSubview(stickFigure)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        self.firstTouch = touch?.location(in: drawingPlace)
        self.insideCanvas = self.drawingPlace.frame.contains((touch?.location(in: self.view))!)
        print(self.insideCanvas)
    }
    
    @IBAction func classTapped(_ sender: UIButton) {
        /*let rectangle = CGRect(x: 100, y: 100, width: 200, height: 250)
        let dumpLayer = CALayer()
        let classDiagram = ClassDiagramView(frame: rectangle, layer: dumpLayer)
        self.drawingPlace.addSubview(classDiagram )*/
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(isUserEditing && self.insideCanvas) {
            // erase sublayers used for drawing
            if(self.drawingPlace.layer.sublayers != nil) {
                for layer in self.drawingPlace.layer.sublayers! {
                    self.drawingPlace.layer.sublayers?.popLast()
                }
                for layer in self.layersFromShapes {
                    self.drawingPlace.layer.addSublayer(layer)
                }
            }
            
            for touch in touches {
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
                    bezier = self.drawRectangle(startPoint: firstTouch!, secondPoint: secondTouch!)
                case .Ellipse:
                    bezier = self.drawEllipse(startPoint: firstTouch!, secondPoint: secondTouch!)
                case .Triangle:
                    bezier = self.drawTriangle(startPoint: firstTouch!, secondPoint: secondTouch!)
                case .Line:
                    bezier.move(to: self.firstTouch!)
                    bezier.addLine(to: secondTouch!)
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
                shape.fillColor = UIColor.white.cgColor
                self.drawingPlace.layer.addSublayer(shape)
                self.currentContext?.addPath((self.currentBezierPath?.cgPath)!)
            }
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(isUserEditing && self.insideCanvas) {
            for touch in touches {
                print("touch ended")
            }
            
            let touch = touches.first
            self.currentContext = nil
            self.currentBezierPath?.close()
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
            } else if(currentShape == Shape.Line) {
                self.drawingPlace.layer.addSublayer(myLayer)
            }
            
            self.layersFromShapes.append((self.drawingPlace.layer.sublayers?.popLast())!)
            for layer in self.drawingPlace.layer.sublayers! {
                self.drawingPlace.layer.sublayers?.popLast()
            }
            for layer in self.layersFromShapes {
                self.drawingPlace.layer.addSublayer(layer)
            }
            self.insideCanvas = false
        }
        
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

    func setUpNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(createClassDiagramAlert), name: NSNotification.Name(rawValue: "createClassDiagramAlert"), object: nil)
    }
    
    @objc func createClassDiagramAlert(sender: AnyObject) {
        var text = sender.userInfo["text"]
        let classDiagram = ClassDiagramView(text: processText(text: text as! String))
        self.drawingPlace.addSubview(classDiagram)
        self.layersFromShapes.append((self.drawingPlace.layer.sublayers?.popLast())!)
        self.drawingPlace.layer.addSublayer(self.layersFromShapes[self.layersFromShapes.count-1])
  
    }
    
    func processText(text: String) -> [String] {
        let separators = CharacterSet(charactersIn: "--")
        let textArray = text.components(separatedBy: separators as CharacterSet)
        print(textArray)
        return textArray
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

