
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

    @IBOutlet weak var optionsView: UIView!
    @IBOutlet weak var drawingPlace: UIView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var colorButton: UIBarButtonItem!
    @IBOutlet weak var stickFigure: UIButton!
    @IBOutlet weak var classButton: UIButton!
    @IBOutlet weak var lineButton: UIButton!
    
    var firstTouch : CGPoint?
    var secondTouch : CGPoint?
    var currentContext : CGContext?
    var currentShape = Shape.None
    var isUserEditingShape: Bool = false
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
    var lineIndexEdit: Int?
    var lineEditing = false
    var lineBeingEdited: Line?
    var addedNewPointToLine = false
    var pointIndexEditing: Int?
    
    // options view
    @IBOutlet weak var firstEndTextField: UITextField!
    @IBOutlet weak var secondEndTextField: UITextField!
    @IBOutlet weak var firstEndAssociationButton: UIButton!
    @IBOutlet weak var firstEndAggregationButton: UIButton!
    @IBOutlet weak var firstEndCompositionButton: UIButton!
    @IBOutlet weak var firstEndInheritenceButton: UIButton!
    @IBOutlet weak var firstEndArrowButton: UIButton!
    @IBOutlet weak var secondEndAssociationButton: UIButton!
    @IBOutlet weak var secondEndAggregationButton: UIButton!
    @IBOutlet weak var secondEndCompositionButton: UIButton!
    @IBOutlet weak var secondEndInheritenceButton: UIButton!
    @IBOutlet weak var secondEndArrowButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.drawingPlace.clipsToBounds = true
        self.cancelButton.isEnabled = false
        self.setUpNotifications()
        self.hideOptionsView()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            self.createClassDiagramAlert(sender: self)
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
    
    func rectangleTapped() {
        self.isUserEditingShape = true
        self.currentShape = Shape.Rectangle
        self.cancelButton.isEnabled = true
    }
    func ellipseTapped() {
        self.isUserEditingShape = true
        self.currentShape = Shape.Ellipse
        self.cancelButton.isEnabled = true
    }
    
    func triangleTapped() {
        self.isUserEditingShape = true
        self.currentShape = Shape.Triangle
        self.cancelButton.isEnabled = true
    }
    
    @IBAction func lineTapped() {
        self.isUserEditingShape = true
        self.currentShape = Shape.Line
        self.cancelButton.isEnabled = true

    }
    
    @IBAction func stickfigureTapped() {
        let stickFigure = StickFigureView()
        self.shapes[stickFigure.uuid] = stickFigure
        self.drawingPlace.addSubview(stickFigure)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.firstTouch = touches.first?.location(in: drawingPlace)
        self.insideCanvas = self.drawingPlace.frame.contains((touches.first?.location(in: self.view))!)
        var lineIndex = 0
        
        for line in self.lines {
            var hitPointTest = line.hitPointTest(touchPoint: self.firstTouch!)
            
            if(hitPointTest != -1) { // editing point in line
                self.editingPointOnLine(line: line, pointBeingEdited: hitPointTest, lineIndex: lineIndex)
                if(hitPointTest == 0) { // first end
                    self.lineBeingEdited?.firstAnchorShapeId = nil
                    self.lineBeingEdited?.firstAnchorShapeIndex = nil
                } else if(hitPointTest == ((self.lineBeingEdited?.points.count)! - 1)) { // second end
                    self.lineBeingEdited?.secondAnchorShapeId = nil
                    self.lineBeingEdited?.secondAnchorShapeIndex = nil
                }
            } else if (line.hitTest(touchPoint: self.firstTouch!)) { // adding angle to line
                self.editingPointOnLine(line: line, pointBeingEdited: -1, lineIndex: lineIndex)
            }
            
            lineIndex += 1
        }
    }
    
    func editingPointOnLine(line: Line, pointBeingEdited: Int, lineIndex: Int) {
        self.pointIndexEditing = pointBeingEdited
        self.lineIndexEdit = lineIndex
        self.lineEditing = true
        self.lineBeingEdited = line
        self.lineEditing = true
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // Line Editing
        if(self.lineEditing && self.pointIndexEditing != -1) { // Editing existing point in line
            self.lineBeingEdited?.points[self.pointIndexEditing!] = (touches.first?.location(in: self.drawingPlace))!
            redrawLine(line: self.lineBeingEdited!)
        } else if(self.lineEditing && !self.addedNewPointToLine) { // Added angle/point to line
            self.addedNewPointToLine = true
            self.lineBeingEdited?.addPoint(point: (touches.first?.location(in: self.drawingPlace))!)
        } else if(self.lineEditing) { // new angle being edited
            self.lineBeingEdited?.points[(self.lineBeingEdited?.hitStartPoint)! + 1] = (touches.first?.location(in: self.drawingPlace))!
            redrawLine(line: self.lineBeingEdited!)
        }
        
        // Shape Editing
        if(isUserEditingShape && self.insideCanvas) {
            if(self.drawingPlace.layer.sublayers != nil) { // redraw layers
                self.redrawLayers()
            }
            
            for touch in touches {
                self.secondTouch = touch.location(in: drawingPlace)
                
                // Prep context for graphics
                self.setContext()
                
                var bezier = UIBezierPath()
                switch self.currentShape {
                case .Rectangle:
                    bezier = self.drawRectangle(startPoint: self.firstTouch!, secondPoint: self.secondTouch!)
                case .Ellipse:
                    bezier = self.drawEllipse(startPoint: self.firstTouch!, secondPoint: self.secondTouch!)
                case .Triangle:
                    bezier = self.drawTriangle(startPoint: self.firstTouch!, secondPoint: self.secondTouch!)
                case .Line:
                    bezier.move(to: self.firstTouch!)
                    bezier.addLine(to: self.secondTouch!)
                case .None:
                    print("nothing")
                }
                
                self.addCurrentBezierPathToContext(bezier: bezier)
                self.addShapeLayer()
            }
        }
    }
    
    func addShapeLayer() {
        let shape = CAShapeLayer()
        shape.frame = (self.drawingPlace.bounds)
        shape.path = self.currentBezierPath?.cgPath;
        shape.strokeColor = UIColor.black.cgColor
        shape.fillColor = self.selectedColor.cgColor
        self.drawingPlace.layer.addSublayer(shape)
    }
    
    func setContext() {
        if(self.currentContext == nil) {
            UIGraphicsBeginImageContext(drawingPlace.frame.size)
            self.currentContext = UIGraphicsGetCurrentContext()
        } else {
            self.currentContext?.clear(CGRect(x: 0, y: 0, width: self.drawingPlace.frame.width, height: self.drawingPlace.frame.height))
        }
    }
    
    func addCurrentBezierPathToContext(bezier: UIBezierPath) {
        self.currentContext?.setLineWidth(1)
        self.currentContext?.addPath(bezier.cgPath)
        self.currentContext?.strokePath()
        self.currentBezierPath = bezier
        self.currentBezierPath?.fill()
        self.currentBezierPath?.stroke()
        self.currentContext?.addPath((self.currentBezierPath?.cgPath)!)
    }
    
    
    func resetLineEditing() {
        self.addedNewPointToLine = false
        self.lineBeingEdited = nil
        self.lineIndexEdit = nil
        self.lineEditing = false
        self.pointIndexEditing = -1
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(self.lineEditing) {
            for (key, shape) in self.shapes {
                var anchorPointTouched = shape.isOnAnchorPoint(touchPoint: (touches.first?.location(in: shape))!)
                if(anchorPointTouched != -1) { // line end point touching anchor of a shape
                    if(lineBeingEdited?.firstAnchorShapeId == nil) { // first end point
                        lineBeingEdited?.firstAnchorShapeIndex = anchorPointTouched
                        lineBeingEdited?.firstAnchorShapeId = shape.uuid
                    } else if(lineBeingEdited?.secondAnchorShapeId == nil) { // second end point
                        lineBeingEdited?.secondAnchorShapeIndex = anchorPointTouched
                        lineBeingEdited?.secondAnchorShapeId = shape.uuid
                    }
                }
            }
            self.resetLineEditing()
            
        } else if(isUserEditingShape && self.insideCanvas) {
            let touch = touches.first
            self.currentContext = nil
            self.selectedColor.setFill()
            self.currentBezierPath?.fill()
            self.currentBezierPath?.stroke()
            self.currentBezierPath?.close()
            let layer = CAShapeLayer()
            layer.path = self.currentBezierPath?.cgPath
            layer.borderWidth = 2
            layer.strokeColor = UIColor.black.cgColor
            
            if(currentShape == Shape.Rectangle) {
                let rectangleView = RectangleView(frame: (self.currentBezierPath?.bounds)!, color: self.selectedColor)
                self.shapes[rectangleView.uuid] = rectangleView
                self.drawingPlace.addSubview(rectangleView)
            } else if(currentShape == Shape.Ellipse) {
                let ellipseView = EllipseView(frame: (self.currentBezierPath?.bounds)!, color: self.selectedColor)
                self.shapes[ellipseView.uuid] = ellipseView
                self.drawingPlace.addSubview(ellipseView)
            } else if(currentShape == Shape.Triangle) {
                let triangleView = TriangleView(frame: (self.currentBezierPath?.bounds)!, color: self.selectedColor)
                self.shapes[triangleView.uuid] = triangleView
                self.drawingPlace.addSubview(triangleView)
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
        self.isUserEditingShape = false
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
            popoverVC.delegate = self
        }
        present(popoverVC, animated: true, completion: nil)
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
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
    
    @objc func onDelete(_ notification:Notification) {
        let uuid = notification.userInfo?["uuid"] as! String
        self.shapes.removeValue(forKey: uuid)
    }
    
    func setUpNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(createClassDiagramAlert), name: NSNotification.Name(rawValue: "createClassDiagramAlert"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(drawLineAlert), name: NSNotification.Name(rawValue: "drawLineAlert"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(movedViewAlert), name: NSNotification.Name(rawValue: "movedView"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onDuplicate(_:)), name: .duplicate, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onDelete(_:)), name: .delete, object: nil)

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
                self.drawLine(line: line)
                    
            } else if(line.secondAnchorShapeId == viewUUID) {
                line.points[line.points.count - 1] = (self.shapes[viewUUID]?.getAnchorPoint(index: line.secondAnchorShapeIndex!))!
                self.drawLine(line: line)
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
            self.redrawLayers()
        }
    }
    
    func drawLine(line: Line) {
        var bezier = UIBezierPath()
        for (index, point) in line.points.enumerated() {
            if(index < line.points.count - 1) {
                bezier.move(to: line.points[index])
                bezier.addLine(to: line.points[index + 1])
            }
        }
        self.currentContext = nil
        bezier.close()
        let layer = CAShapeLayer()
        layer.path = bezier.cgPath
        layer.borderWidth = 2
        layer.strokeColor = UIColor.black.cgColor
        line.layer = layer
        redrawLayers()
    }
    
    func redrawLine(line: Line) {
        var bezier = UIBezierPath()
        for (index, point) in line.points.enumerated() {
            if(index < line.points.count - 1) {
                bezier.move(to: line.points[index])
                bezier.addLine(to: line.points[index + 1])
            }
        }
        self.currentContext = nil
        bezier.close()
        let layer = CAShapeLayer()
        layer.path = bezier.cgPath
        layer.borderWidth = 2
        layer.strokeColor = UIColor.black.cgColor
        line.layer = layer
        redrawLayers()
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
        for layer in self.drawingPlace.layer.sublayers! {
            self.drawingPlace.layer.sublayers?.popLast()
        }
       for (uuid, view) in self.shapes{
            self.drawingPlace.layer.addSublayer(view.layer)
        }
        
        for line in lines {
            self.drawingPlace.layer.addSublayer(line.layer!)
        }
    }
    
    func hideOptionsView() {
        self.optionsView.isHidden = true
    }
    
    func showOptionsView() {
        self.optionsView.isHidden = false
    }

}


//  DrawViewController.swift
//  poly-paint-ios
//
//  Created by Tomato on 2018-10-25.
//  Copyright © 2018 PolyAcme. All rights reserved.
//


