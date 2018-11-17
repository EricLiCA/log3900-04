
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
    @IBOutlet weak var insertButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var colorButton: UIBarButtonItem!
    @IBOutlet weak var redoButton: UIBarButtonItem!
    @IBOutlet weak var undoButton: UIBarButtonItem!
    
    var firstTouch : CGPoint?
    var secondTouch : CGPoint?
    var currentContext : CGContext?
    var currentShape = Shape.None
    var isUserEditing: Bool = false
    var currentBezierPath: UIBezierPath?
    var insideCanvas = false
    var selectedColor : UIColor = UIColor.black
    var startPointOfLine: CGPoint?
    var endPointOfLine: CGPoint?
    var startPointView: BasicShapeView?
    var endPointView: BasicShapeView?
    var startAnchorNumber: Int?
    var endAnchorNumber: Int?
    var lines = [Line]()
    var shapes = [String: BasicShapeView]()
    var undoRedoManager = UndoRedoManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.drawingPlace.clipsToBounds = true
        self.cancelButton.isEnabled = false
        self.setUpNotifications()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func insertTapped(_ sender: UIBarButtonItem) {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let drawRectangleAction = UIAlertAction(title: "Rectangle", style: .default, handler: { (alert: UIAlertAction!) -> Void in
            self.rectangleTapped()
        })
        alertController.addAction(drawRectangleAction)
        
        
        let drawEllipseAction = UIAlertAction(title: "Ellipse", style: .default, handler: { (alert: UIAlertAction!) -> Void in
            self.ellipseTapped()
        })
        alertController.addAction(drawEllipseAction)
        
        
        let drawTriangleAction = UIAlertAction(title: "Triangle", style: .default, handler: { (alert: UIAlertAction!) -> Void in
            self.triangleTapped()
        })
        alertController.addAction(drawTriangleAction)
        
        let drawActorAction = UIAlertAction(title: "Actor", style: .default, handler: { (alert: UIAlertAction!) -> Void in
            self.stickfigureTapped()
        })
        alertController.addAction(drawActorAction)
        
        let drawClassAction = UIAlertAction(title: "Class", style: .default, handler: { (alert: UIAlertAction!) -> Void in
            self.performSegue(withIdentifier: "toCreateClass", sender: self)
        })
        alertController.addAction(drawClassAction)
        
        let drawLineAction = UIAlertAction(title: "Line", style: .default, handler: { (alert: UIAlertAction!) -> Void in
            self.lineTapped()
        })
        alertController.addAction(drawLineAction)
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: { (alert: UIAlertAction!) -> Void in
        })
        alertController.addAction(cancelAction)
        
        
        
        if let popoverController = alertController.popoverPresentationController {
            popoverController.barButtonItem = sender
        }
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    @IBAction func cancelTapped(_ sender: UIBarButtonItem) {
        self.stopDrawing()
    }
    
    @IBAction func undoTapped(_ sender: Any) {
        self.undoRedoManager.undo()
    }
    
    @IBAction func redoTapped(_ sender: Any) {
        self.undoRedoManager.redo()
    }
    
    func rectangleTapped() {
        if(self.currentShape == Shape.Rectangle) {
            self.isUserEditing = false
            self.currentShape = Shape.None
        } else {
            self.isUserEditing = true
            self.currentShape = Shape.Rectangle
            self.cancelButton.isEnabled = true
        }
    }
    func ellipseTapped() {
        if(self.currentShape == Shape.Ellipse) {
            self.isUserEditing = false
        } else {
            self.isUserEditing = true
            self.currentShape = Shape.Ellipse
            self.cancelButton.isEnabled = true
        }
        
    }
    
    func triangleTapped() {
        if(self.currentShape == Shape.Triangle) {
            self.isUserEditing = false
            self.currentShape = Shape.None
        } else {
            self.isUserEditing = true
            self.currentShape = Shape.Triangle
            self.cancelButton.isEnabled = true
        }
    }
    
    func lineTapped() {
        if(self.currentShape == Shape.Line) {
            self.isUserEditing = false
            self.currentShape = Shape.None
        } else {
            self.isUserEditing = true
            self.currentShape = Shape.Line
            self.cancelButton.isEnabled = true
        }
    }
    
    func stickfigureTapped() {
        let stickFigure = StickFigureView()
        self.shapes[stickFigure.uuid] = stickFigure
        self.drawingPlace.addSubview(stickFigure)
        //self.layersFromShapes.append(stickFigure.layer)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        self.firstTouch = touch?.location(in: drawingPlace)
        self.insideCanvas = self.drawingPlace.frame.contains((touch?.location(in: self.view))!)
        
        for line in self.lines {
            line.hitTest(touchPoint: self.firstTouch!)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(isUserEditing && self.insideCanvas) {
            // erase sublayers used for drawing
            if(self.drawingPlace.layer.sublayers != nil) {
                self.redrawLayers()
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
                
                self.currentContext?.setLineWidth(1)
                self.currentBezierPath = bezier
                self.currentBezierPath?.fill()
                self.currentBezierPath?.stroke()
                self.currentContext?.addPath(bezier.cgPath)
                self.currentContext?.strokePath()
                let shape = CAShapeLayer()
                shape.frame = (self.drawingPlace.bounds)
                shape.path = self.currentBezierPath?.cgPath;
                shape.strokeColor = UIColor.black.cgColor
                shape.fillColor = self.selectedColor.cgColor
                self.drawingPlace.layer.addSublayer(shape)
                self.currentContext?.addPath((self.currentBezierPath?.cgPath)!)
            }
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(isUserEditing && self.insideCanvas) {
            let touch = touches.first
            self.currentContext = nil
            self.selectedColor.setFill()
            self.currentBezierPath?.fill()
            self.currentBezierPath?.stroke()
            self.currentBezierPath?.close()
            let myLayer = CAShapeLayer()
            myLayer.path = self.currentBezierPath?.cgPath
            myLayer.borderWidth = 2
            myLayer.strokeColor = UIColor.black.cgColor
            let layer = CAShapeLayer()
            layer.path = self.currentBezierPath?.cgPath
            layer.borderWidth = 2
            layer.strokeColor = UIColor.black.cgColor
            
            if(currentShape == Shape.Rectangle) {
                let rectangleView = RectangleView(frame: (self.currentBezierPath?.bounds)!, color: self.selectedColor)
                self.shapes[rectangleView.uuid] = rectangleView
                self.drawingPlace.addSubview(rectangleView)
                self.undoRedoManager.alertInsertion(shapeType: rectangleView.shapeType!, frame: rectangleView.frame, color: rectangleView.color!, uuid: rectangleView.uuid)
                
            } else if(currentShape == Shape.Ellipse) {
                let ellipseView = EllipseView(frame: (self.currentBezierPath?.bounds)!, color: self.selectedColor)
                self.shapes[ellipseView.uuid] = ellipseView
                self.drawingPlace.addSubview(ellipseView)
                self.undoRedoManager.alertInsertion(shapeType: ellipseView.shapeType!, frame: ellipseView.frame, color: ellipseView.color!, uuid: ellipseView.uuid)
                
            } else if(currentShape == Shape.Triangle) {
                let triangleView = TriangleView(frame: (self.currentBezierPath?.bounds)!, color: self.selectedColor)
                self.shapes[triangleView.uuid] = triangleView
                self.drawingPlace.addSubview(triangleView)
                self.undoRedoManager.alertInsertion(shapeType: triangleView.shapeType!, frame: triangleView.frame, color: triangleView.color!, uuid: triangleView.uuid)
                
            } else if(currentShape == Shape.Line) {
                var line = Line(layer: layer)
                line.points.append(self.firstTouch!)
                line.points.append(self.secondTouch!)
                self.drawingPlace.layer.addSublayer(line.layer!)
                lines.append(line)
            }
            self.drawingPlace.layer.sublayers?.popLast()
            self.redrawLayers()
            self.insideCanvas = false
        }
        self.stopDrawing()
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
    
    func stopDrawing(){
        self.isUserEditing = false
        self.currentShape = Shape.None
        self.cancelButton.isEnabled = false;
    }
    
    @IBAction func colorPickerButton(_ sender: UIBarButtonItem) {
        
        let popoverVC = storyboard?.instantiateViewController(withIdentifier: "colorPickerPopover") as! ColorPickerViewController
        popoverVC.modalPresentationStyle = .popover
        popoverVC.preferredContentSize = CGSize(width: 284, height: 446)
        if let popoverController = popoverVC.popoverPresentationController {
            popoverController.barButtonItem = sender
            popoverController.sourceRect = CGRect(x: 0, y: 0, width: 85, height: 30)
            popoverController.permittedArrowDirections = .any
           // popoverController.delegate? = self
            popoverVC.delegate = self
        }
        present(popoverVC, animated: true, completion: nil)
    }
    
   /* func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }*/
    
    func setButtonColor (_ color: UIColor) {
        self.colorButton.tintColor = color
        self.selectedColor = color
    }
    
    @objc func onDuplicate(_ notification:Notification) {
        let shapeType = notification.userInfo?["shapeType"] as! String
        
        
        if shapeType == "RECTANGLE" {
            let view = RectangleView(frame: notification.userInfo?["frame"] as! CGRect, color: notification.userInfo?["color"] as! UIColor)
            view.center.x = 0 + view.frame.width/2
            view.center.y = 0 + view.frame.height/2
            self.shapes[view.uuid] = view
            self.drawingPlace.addSubview(view)
        }
            
        else if shapeType == "TRIANGLE" {
            let view = TriangleView(frame: notification.userInfo?["frame"] as! CGRect, color: notification.userInfo?["color"] as! UIColor)
            view.center.x = 0 + view.frame.width/2
            view.center.y = 0 + view.frame.height/2
            self.shapes[view.uuid] = view
            self.drawingPlace.addSubview(view)
        }
            
        else  if shapeType == "ELLIPSE" {
            let view = EllipseView(frame: notification.userInfo?["frame"] as! CGRect, color: notification.userInfo?["color"] as! UIColor)
            view.center.x = 0 + view.frame.width/2
            view.center.y = 0 + view.frame.height/2
            self.shapes[view.uuid] = view
            self.drawingPlace.addSubview(view)
        }
       self.drawingPlace.layer.sublayers?.popLast()
        //self.layersFromShapes.append((self.drawingPlace.layer.sublayers?.popLast())!)
        self.redrawLayers()
        self.insideCanvas = false
        
    }
    
    @objc func onRestoreUndoRedo(_ notification:Notification) {
        let shapeType = notification.userInfo?["shapeType"] as! String
        
        if shapeType == "RECTANGLE" {
            let view = RectangleView(frame: notification.userInfo?["frame"] as! CGRect, color: notification.userInfo?["color"] as! UIColor)
            view.uuid = notification.userInfo?["uuid"] as! String
            self.shapes[view.uuid] = view
            self.drawingPlace.addSubview(view)
        }
            
        else if shapeType == "TRIANGLE" {
            let view = TriangleView(frame: notification.userInfo?["frame"] as! CGRect, color: notification.userInfo?["color"] as! UIColor)
            view.uuid = notification.userInfo?["uuid"] as! String
            self.shapes[view.uuid] = view
            self.drawingPlace.addSubview(view)
        }
            
        else  if shapeType == "ELLIPSE" {
            let view = EllipseView(frame: notification.userInfo?["frame"] as! CGRect, color: notification.userInfo?["color"] as! UIColor)
            view.uuid = notification.userInfo?["uuid"] as! String
            self.shapes[view.uuid] = view
            self.drawingPlace.addSubview(view)
        }
        self.drawingPlace.layer.sublayers?.popLast()
        self.redrawLayers()
        self.insideCanvas = false
        self.stopDrawing()
    }
    
    @objc func onDelete(_ notification:Notification) {
        let uuid = notification.userInfo?["uuid"] as! String
        let shape = self.shapes[uuid]
        self.undoRedoManager.alertDeletion(shapeType: (shape?.shapeType)!, frame: (shape?.frame)!, color:(shape?.color)!, uuid: uuid)
        shape?.removeFromSuperview()
        self.shapes.removeValue(forKey: uuid)
    }
    
    @objc func onDeletionUndoRedo(_ notification:Notification) {
        let uuid = notification.userInfo?["uuid"] as! String
        let shape = self.shapes[uuid]
        shape?.removeFromSuperview()
        self.shapes.removeValue(forKey: uuid)
    }
    
    func setUpNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(createClassDiagramAlert), name: NSNotification.Name(rawValue: "createClassDiagramAlert"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(drawLineAlert), name: NSNotification.Name(rawValue: "drawLineAlert"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(movedViewAlert), name: NSNotification.Name(rawValue: "movedView"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onDuplicate(_:)), name: .duplicate, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onDelete(_:)), name: .delete, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onRestoreUndoRedo(_:)), name: .restoreUndoRedo, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onDeletionUndoRedo(_:)), name: .deletionUndoRedo, object: nil)
    }
    
    @objc func createClassDiagramAlert(sender: AnyObject) {
        var text = sender.userInfo["text"]
        let classDiagram = ClassDiagramView(text: processText(text: text as! String))
        self.shapes[classDiagram.uuid] = classDiagram
        self.drawingPlace.addSubview(classDiagram)
    }
    
    @objc func movedViewAlert(sender: AnyObject) {
        let viewUUID = sender.userInfo["view"] as! String
        for line in self.lines {
            if(line.firstAnchorShapeId == viewUUID) {
                line.points[0] = (self.shapes[viewUUID]?.getAnchorPoint(index: line.firstAnchorShapeIndex!))!
                let bezier = UIBezierPath()
                bezier.move(to: line.points[0])
                bezier.addLine(to: line.points[1])
                line.layer?.path = bezier.cgPath
            } else if(line.secondAnchorShapeId == viewUUID) {
                line.points[1] = (self.shapes[viewUUID]?.getAnchorPoint(index: line.secondAnchorShapeIndex!))!
                let bezier = UIBezierPath()
                bezier.move(to: line.points[0])
                bezier.addLine(to: line.points[1])
                line.layer?.path = bezier.cgPath
            }
        }
    }
    
    @objc func drawLineAlert(sender: AnyObject) {
        let view = sender.userInfo["view"] as! BasicShapeView
        if(self.startPointOfLine == nil) {
            self.startPointOfLine = sender.userInfo["point"] as! CGPoint
            self.startPointView = sender.userInfo["view"] as! BasicShapeView
            self.startAnchorNumber = sender.userInfo["anchorNumber"] as! Int
        } else if(view.uuid == self.startPointView?.uuid) {
            self.resetLineEndPoints()
        } else if(self.endPointOfLine == nil) {
            self.endPointView = sender.userInfo["view"] as! BasicShapeView
            self.endPointOfLine = sender.userInfo["point"] as! CGPoint
            self.endAnchorNumber = sender.userInfo["anchorNumber"] as! Int
            // draw line
            var bezier = UIBezierPath()
            bezier.move(to: self.startPointOfLine!)
            bezier.addLine(to: self.endPointOfLine!)
            self.currentContext = nil
            bezier.close()
            let layer = CAShapeLayer()
            layer.path = bezier.cgPath
            layer.borderWidth = 2
            layer.strokeColor = UIColor.black.cgColor
            var line = Line(layer: layer)
            line.points.append(self.startPointOfLine!)
            line.points.append(self.endPointOfLine!)
            line.firstAnchorShapeId = self.startPointView?.uuid
            line.firstAnchorShapeIndex = self.startAnchorNumber
            line.secondAnchorShapeId = self.endPointView?.uuid
            line.secondAnchorShapeIndex = self.endAnchorNumber
            self.lines.append(line)
            self.drawingPlace.layer.addSublayer(line.layer!)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "lineDrawnAlert"), object: nil)
            self.resetLineEndPoints()
          //  self.layersFromShapes.append((self.drawingPlace.layer.sublayers?.popLast())!)
            self.redrawLayers()
        }
    }
    
    func resetLineEndPoints() {
        self.startPointOfLine = nil
        self.startPointView = nil
        self.startAnchorNumber = nil
        self.endPointOfLine = nil
        self.endPointView = nil
        self.endAnchorNumber = nil
    }
    
    func processText(text: String) -> [String] {
        let separators = CharacterSet(charactersIn: "--")
        let textArray = text.components(separatedBy: separators as CharacterSet)
        return textArray
    }
    
    func redrawLayers() {
        if let sublayers = self.drawingPlace.layer.sublayers {
            for layer in sublayers {
                self.drawingPlace.layer.sublayers?.popLast()
            }
        }
        for (uuid, view) in self.shapes{
            self.drawingPlace.layer.addSublayer(view.layer)
        }
        
        for line in lines {
            self.drawingPlace.layer.addSublayer(line.layer!)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCreateClass" {
            let CreateClassVC = segue.destination as! NewClassViewController
        }
    }
    
} //end class





