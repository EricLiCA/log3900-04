
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
    case UseCase
    case None
}

class DrawViewController: UIViewController {
    
    
    @IBOutlet weak var optionsView: UIView!
    @IBOutlet weak var drawingPlace: UIView!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var chatButton: UIBarButtonItem!
    @IBOutlet weak var selectedColorButton: UIButton!
    @IBOutlet weak var lassoButton: UIButton!
    @IBOutlet weak var rectangleButton: UIButton!
    @IBOutlet weak var ellipseButton: UIButton!
    @IBOutlet weak var triangleButton: UIButton!
    @IBOutlet weak var stickFigureButton: UIButton!
    
    var firstTouch : CGPoint?
    var secondTouch : CGPoint?
    var currentContext : CGContext?
    var currentShape = Shape.None
    var isUserEditingShape: Bool = false
    var currentBezierPath: UIBezierPath?
    var insideCanvas = false
    var selectedColor : UIColor = UIColor.white
    var startPointOfLine: CGPoint?
    var endPointOfLine: CGPoint?
    var startPointView: BasicShapeView?
    var endPointView: BasicShapeView?
    var startAnchorNumber: Int?
    var endAnchorNumber: Int?
    var lines = [Line]()
    var shapes = [String: BasicShapeView]()
    var undoRedoManager = UndoRedoManager()
    var drawingSocketManager = DrawingSocketManager()
    var image: Image?
    var imageLoader = ImageLoader()
    var lineIndexEdit: Int?
    var lineEditing = false
    var lineBeingEdited: Line?
    var addedNewPointToLine = false
    var pointIndexEditing: Int?
    var drawLineAlerted = false
    var useCaseText = ""
    
    // LASSO
    var lassoActive = false
    var lassoShapes = [String]()
    var finishedDrawingLasso = false
    var inaccessibleShapes = [String]()
    
    // Options View
    var firstEndRelation: Relation?
    var secondEndRelation: Relation?
    var firstEndLabel: String?
    var secondEndLabel: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.drawingPlace.clipsToBounds = true
        self.cancelButton.isEnabled = false
        self.setUpNotifications()
        self.selectedColorButtonDefault()
        ChatModel.instance.notificationsSubject.asObservable().subscribe(onNext: {
            notifications in
            if notifications == 0 {
                self.chatButton.image = #imageLiteral(resourceName: "Chat")
            } else {
                self.chatButton.image = #imageLiteral(resourceName: "UnreadMessage")
            }
        })
        self.navigationItem.title = image?.title!
        self.handleSocketEmits()
        self.shapes = [String: BasicShapeView]()
        self.disableEdittingButtons()
        self.drawingPlace.layer.borderWidth = 2
        self.drawingPlace.layer.borderColor = UIColor.black.cgColor
        // Do any additional setup after loading the view.
    }
    
    
    func resetBasicShapeButton(){
        self.triangleButton.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.ellipseButton.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.rectangleButton.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    func disableEdittingButtons() {

    }

    @IBAction func deleteTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func pasteTapped(_ sender: Any) {
    }
    
    @IBAction func copyTapped(_ sender: UIButton) {
    }
    
    @IBAction func cutTapped(_ sender: UIButton) {
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
        super.viewWillDisappear(animated)
    }
    
    func setDrawingPlace() {
        self.drawingPlace.layer.borderWidth = 2
        self.drawingPlace.layer.borderColor = UIColor.black.cgColor
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func resetTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Warning", message: "Resetting the image will erase all shapes", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style:  UIAlertAction.Style.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Continue", style: UIAlertAction.Style.default,handler: { action in
            self.deleteAllShapes()
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func deleteAllShapes() {
        self.shapes.removeAll()
        self.lines.removeAll()
        for view in self.drawingPlace.subviews {
            view.removeFromSuperview()
        }
        for layer in self.drawingPlace.layer.sublayers! {
            self.drawingPlace.layer.sublayers?.popLast()
        }
        self.drawingSocketManager.clearCanvas()
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeLeft
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    @IBAction func cancelTapped(_ sender: UIBarButtonItem) {
        self.stopDrawing()
    }
    
    @IBAction func rectangleTapped(_ sender: UIButton) {
        self.rectangleTapped()
        self.rectangleButton.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    }
    @IBAction func undoTapped(_ sender: Any) {
        self.undoRedoManager.undo()
    }
    @IBAction func redoTapped(_ sender: Any) {
        self.undoRedoManager.redo()
    }
    
    
    @IBAction func ellipseTapped(_ sender: UIButton) {
        self.ellipseTapped()
        self.ellipseButton.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    }
    
    @IBAction func triangleTapped(_ sender: UIButton) {
        self.triangleTapped()
        self.triangleButton.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    }
    
    @IBAction func lineTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func useCaseTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func selectedColorTapped(_ sender: UIButton) {
    }
    
    @IBAction func lassoTapped(_ sender: Any) {
        if (self.lassoActive) {
            self.lassoActive = false
            self.cancelButton.isEnabled = false
            self.lassoButton.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.unprotectLassoShapes()
        } else {
            self.lassoActive = true
            self.cancelButton.isEnabled = true
            self.lassoButton.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        }
    }
    
    func selectedColorButtonDefault() {
        self.selectedColorButton.backgroundColor = UIColor.white
        self.selectedColorButton.layer.borderWidth = 3
        self.selectedColorButton.layer.borderColor = UIColor.black.cgColor
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
    
    func useCaseTapped() {
        self.isUserEditingShape = true
        self.currentShape = Shape.UseCase
        self.cancelButton.isEnabled = true
    }
    
    func triangleTapped() {
        self.isUserEditingShape = true
        self.currentShape = Shape.Triangle
        self.cancelButton.isEnabled = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.firstTouch = touches.first?.location(in: drawingPlace)
        self.insideCanvas = self.drawingPlace.frame.contains((touches.first?.location(in: self.view))!)
        var lineIndex = 0
        var foundLine = false
        self.hideAllAnchorsNotInLasso()
        if(!self.lassoActive) {
            while(!foundLine && self.lines.count > lineIndex) {
                var hitPointTest = self.lines[lineIndex].hitPointTest(touchPoint: self.firstTouch!)
                
                if(hitPointTest != -1) { // editing point in line
                    self.editingPointOnLine(line: self.lines[lineIndex], pointBeingEdited: hitPointTest, lineIndex: lineIndex)
                    if(hitPointTest == 0) { // first end
                        self.lineBeingEdited?.firstAnchorShapeId = nil
                        self.lineBeingEdited?.firstAnchorShapeIndex = nil
                    } else if(hitPointTest == ((self.lineBeingEdited?.points.count)! - 1)) { // second end
                        self.lineBeingEdited?.secondAnchorShapeId = nil
                        self.lineBeingEdited?.secondAnchorShapeIndex = nil
                    }
                    self.selectLine(line: self.lines[lineIndex])
                    foundLine = true
                } else if (self.lines[lineIndex].hitTest(touchPoint: self.firstTouch!)) { // adding angle to line
                    self.editingPointOnLine(line: self.lines[lineIndex], pointBeingEdited: -1, lineIndex: lineIndex)
                    foundLine = true
                    self.selectLine(line: self.lines[lineIndex])
                } else {
                    self.unselectLine(line: self.lines[lineIndex])
                }
                
                lineIndex += 1
            }
            
            /*for line in self.lines {
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
            }*/
            
            if(self.lineBeingEdited == nil) {
                self.disableEdittingButtons()
            }
        }
    }
    
    func hideAllAnchorsNotInLasso() {
        for (key, shape) in self.shapes {
            if(!lassoShapes.contains(key)) {
                shape.hideAnchorPoints()
            }
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
            drawLine(line: self.lineBeingEdited!)
        } else if(self.lineEditing && !self.addedNewPointToLine) { // Added angle/point to line
            self.addedNewPointToLine = true
            self.lineBeingEdited?.addPoint(point: (touches.first?.location(in: self.drawingPlace))!)
        } else if(self.lineEditing) { // new angle being edited
            self.lineBeingEdited?.points[(self.lineBeingEdited?.hitStartPoint)! + 1] = (touches.first?.location(in: self.drawingPlace))!
            drawLine(line: self.lineBeingEdited!)
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
                case .UseCase:
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
        } else if (self.lassoActive && !self.finishedDrawingLasso) {
            self.drawingLasso(touches)
        }
    }
    
    func drawingLasso(_ touches: Set<UITouch>) {
        if(self.drawingPlace.layer.sublayers != nil) { // redraw layers
            self.redrawLayers()
        }
        
        for touch in touches {
            self.secondTouch = touch.location(in: drawingPlace)
            self.setContext()
            var bezier = UIBezierPath()
            bezier = self.drawRectangle(startPoint: self.firstTouch!, secondPoint: self.secondTouch!)
            self.addCurrentBezierPathToContext(bezier: bezier)
            self.addShapeLayer()
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
            //UIGraphicsBeginImageContext(drawingPlace.frame.size)
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
                let rectangleView = RectangleView(frame: (self.currentBezierPath?.bounds)!, color: self.selectedColor, index: self.shapes.count + 1, imageID: (self.image?.id)!)
                print(rectangleView.index!)
                print(self.shapes.count + 1)
                self.shapes[rectangleView.uuid!] = rectangleView
                self.drawingPlace.addSubview(rectangleView)
                self.undoRedoManager.alertInsertion(shape:rectangleView)
                self.drawingSocketManager.addShape(shape: rectangleView, imageID: (self.image?.id)!)
                
            } else if(currentShape == Shape.Ellipse) {
                let ellipseView = EllipseView(frame: (self.currentBezierPath?.bounds)!, color: self.selectedColor, useCase: "", index: self.shapes.count + 1, imageID: (self.image?.id)!)
                self.shapes[ellipseView.uuid!] = ellipseView
                self.drawingPlace.addSubview(ellipseView)
                self.useCaseText = ""
                self.undoRedoManager.alertInsertion(shape:ellipseView)
                self.drawingSocketManager.addShape(shape: ellipseView, imageID: (self.image?.id)!)
                
            } else if(currentShape == Shape.UseCase) {
                let ellipseView = EllipseView(frame: (self.currentBezierPath?.bounds)!, color: self.selectedColor, useCase: self.useCaseText, index: self.shapes.count + 1, imageID: (self.image?.id)!)
                self.shapes[ellipseView.uuid!] = ellipseView
                self.drawingPlace.addSubview(ellipseView)
                self.useCaseText = ""
                self.undoRedoManager.alertInsertion(shape:ellipseView)
                self.drawingSocketManager.addShape(shape: ellipseView, imageID: (self.image?.id)!)
                
            } else if(currentShape == Shape.Triangle) {
                let triangleView = TriangleView(frame: (self.currentBezierPath?.bounds)!, color: self.selectedColor, index: self.shapes.count + 1, imageID: (self.image?.id)!)
                self.shapes[triangleView.uuid!] = triangleView
                self.drawingPlace.addSubview(triangleView)
                self.undoRedoManager.alertInsertion(shape:triangleView)
                self.drawingSocketManager.addShape(shape: triangleView, imageID: (self.image?.id)!)
                
            } else if(currentShape == Shape.Line) {
                var line = Line(layer: layer, startPoint: self.firstTouch!, endPoint: self.secondTouch!, firstEndRelation: self.firstEndRelation!, secondEndRelation: self.secondEndRelation!, firstEndTextField: self.firstEndLabel!, secondEndTextField: self.secondEndLabel!)
                self.drawingPlace.layer.addSublayer(line.layer!)
                lines.append(line)
                self.undoRedoManager.alertLineInsertion(line: line)
                self.selectLine(line: line)
            }
            
            self.drawingPlace.layer.sublayers?.popLast()
            self.redrawLayers()
            self.insideCanvas = false
            
        } else if (self.lassoActive && !self.finishedDrawingLasso) {
            self.selectLassoShapes()
            self.redrawLayers()
            self.protectLassoShapes()
        }
        
        self.stopDrawing()
    }
    
    // TODO: send to server
    func protectLassoShapes() {
        self.finishedDrawingLasso = true
    }
    
    // TODO: send to server
    func unprotectLassoShapes() {
        self.finishedDrawingLasso = false
        for shapeUUID in self.lassoShapes {
            self.shapes[shapeUUID]?.hideAnchorPoints()
        }
        self.finishedDrawingLasso = false
        self.lassoShapes = [String]()
    }
    
    // TODO: receive from server
    func setInaccessibleShapes(shapesUUID: [String]) {
        self.inaccessibleShapes = shapesUUID
    }
    
    func selectLassoShapes() {
        for (_, shape) in self.shapes {
            if((self.currentBezierPath?.bounds.contains(shape.frame.origin))!) {
                
                self.lassoShapes.append(shape.uuid!)
                shape.showAnchorPoints()
            }
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
        self.cancelButton.isEnabled = false
        self.resetBasicShapeButton()
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    func setButtonColor (_ color: UIColor) {
        self.selectedColor = color
        self.selectedColorButton.backgroundColor = color
    }
    
    @objc func onDuplicate(_ notification:Notification) {
        let shapeType = notification.userInfo?["shapeType"] as! String
        
        
        if shapeType == "RECTANGLE" {
            let view = RectangleView(frame: notification.userInfo?["frame"] as! CGRect, color: notification.userInfo?["color"] as! UIColor, index: self.shapes.count + 1, imageID: (self.image?.id)!)
            view.center.x = 0 + view.frame.width/2
            view.center.y = 0 + view.frame.height/2
            print("mamamamamaamamamamamamamamamamamamaamamamammaamam" , view.uuid!)
            self.shapes[view.uuid!] = view
            self.drawingPlace.addSubview(view)
            self.drawingSocketManager.addShape(shape: view, imageID: (self.image?.id)!)
            // self.drawingPlace.layer.addSublayer(view.layer)
        }
            
        else if shapeType == "TRIANGLE" {
            let view = TriangleView(frame: notification.userInfo?["frame"] as! CGRect, color: notification.userInfo?["color"] as! UIColor, index: self.shapes.count + 1, imageID: (self.image?.id)!)
            view.center.x = 0 + view.frame.width/2
            view.center.y = 0 + view.frame.height/2
            self.shapes[view.uuid!] = view
            self.drawingPlace.addSubview(view)
            self.drawingSocketManager.addShape(shape: view, imageID: (self.image?.id)!)
            //self.drawingPlace.layer.addSublayer(view.layer)
        }
            
        else  if shapeType == "ELLIPSE" {
            let view = EllipseView(frame: notification.userInfo?["frame"] as! CGRect, color: notification.userInfo?["color"] as! UIColor, useCase: "", index: self.shapes.count + 1, imageID: (self.image?.id)!)
            view.center.x = 0 + view.frame.width/2
            view.center.y = 0 + view.frame.height/2
            self.shapes[view.uuid!] = view
            self.drawingPlace.addSubview(view)
            self.drawingSocketManager.addShape(shape: view, imageID: (self.image?.id)!)
            //self.drawingPlace.layer.addSublayer(view.layer)
        }
            
        else  if shapeType == "USE" {
            let view = EllipseView(frame: notification.userInfo?["frame"] as! CGRect, color: notification.userInfo?["color"] as! UIColor, useCase: notification.userInfo?["useCase"] as! String, index: self.shapes.count + 1,  imageID: (self.image?.id)!)
            view.center.x = 0 + view.frame.width/2
            view.center.y = 0 + view.frame.height/2
            self.shapes[view.uuid!] = view
            self.drawingPlace.addSubview(view)
            self.drawingSocketManager.addShape(shape: view, imageID: (self.image?.id)!)
            //self.drawingPlace.layer.addSublayer(view.layer)
        }
            
        else  if shapeType == "ACTOR" {
            let view = StickFigureView(actorName: notification.userInfo?["actor"] as! String, x: 0, y:0, height: 60 , width: 50, index: self.shapes.count + 1,  imageID: (self.image?.id)!)
            view.center.x = 0 + view.frame.width/2
            view.center.y = 0 + view.frame.height/2
            self.shapes[view.uuid!] = view
            self.drawingPlace.addSubview(view)
            self.drawingSocketManager.addShape(shape: view, imageID: (self.image?.id)!)
            //self.drawingPlace.layer.addSublayer(view.layer)
        }
            
        else if shapeType == "CLASS" {
            let view = ClassDiagramView(text: notification.userInfo?["text"] as! [String], x: notification.userInfo?["x"] as! CGFloat, y: notification.userInfo?["y"] as! CGFloat, height: notification.userInfo?["height"] as! CGFloat, width: notification.userInfo?["width"] as! CGFloat, index: self.shapes.count + 1,  imageID: (self.image?.id)!)
            view.center.x = 0 + view.frame.width/2
            view.center.y = 0 + view.frame.height/2
            self.shapes[view.uuid!] = view
            self.drawingPlace.addSubview(view)
            self.drawingSocketManager.addShape(shape: view, imageID: ((self.image?.id)!))
            //self.drawingPlace.layer.addSublayer(view.layer)
        }
    }
    
    @objc func onRestoreUndoRedo(_ notification:Notification) {
        let shape = notification.userInfo?["shape"] as! BasicShapeView
        let shapeType = shape.shapeType
        
        if (shapeType != "LINE") {
            let view = shape
            self.shapes[view.uuid!] = view
            self.drawingPlace.addSubview(view)
            self.drawingSocketManager.addShape(shape: view,  imageID: (self.image?.id)!)
            self.drawingPlace.layer.addSublayer(view.layer)
        }
    }
    
    @objc func onDelete(_ notification:Notification) {
        let uuid = notification.userInfo?["uuid"] as! String
        print("the id isssssssssssssssss")
        print(uuid)
        let shape = self.shapes[uuid]!
        print("yoooooo" ,shape)
        self.undoRedoManager.alertDeletion(shape: shape)
        shape.removeFromSuperview()
        self.shapes.removeValue(forKey: uuid)
        self.drawingSocketManager.removeShape(shape: shape)
    }
    
    @objc func onDeletionUndoRedo(_ notification:Notification) {
        let uuid = notification.userInfo?["uuid"] as! String
        let shape = self.shapes[uuid]
        shape?.removeFromSuperview()
        self.shapes.removeValue(forKey: uuid)
        self.drawingSocketManager.removeShape(shape: shape!)
    }
    
    @objc func onDeletionLineUndoRedo(_ notification:Notification) {
        let line = notification.userInfo?["line"] as! Line
        if let index = self.lines.index(of: line) {
            self.lines.remove(at: index)
        }
        self.redrawLayers()
        self.drawingSocketManager.removeLine(shape: line)
    }
    
    @objc func onRestoreLineUndoRedo(_ notification:Notification) {
        let line = notification.userInfo?["line"] as! Line
        self.lines.append(line)
        self.redrawLayers()
        self.drawingSocketManager.addLine(shape: line,  imageID: (self.image?.id)!)
    }
    
    func setUpNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(createClassDiagramAlert), name: NSNotification.Name(rawValue: "createClassDiagramAlert"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(drawLineAlert), name: NSNotification.Name(rawValue: "drawLineAlert"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(movedViewAlert), name: NSNotification.Name(rawValue: "movedView"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onDuplicate(_:)), name: .duplicate, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onDelete(_:)), name: .delete, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onRestoreUndoRedo(_:)), name: .restoreUndoRedo, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onDeletionUndoRedo(_:)), name: .deletionUndoRedo, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(relationInfoAlert), name: NSNotification.Name(rawValue: "relationInfoAlert"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(relationInfoCancelAlert), name: NSNotification.Name(rawValue: "relationInfoCancelAlert"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setColorAlert), name: NSNotification.Name(rawValue: "setColorAlert"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(createUseCaseAlert), name: NSNotification.Name(rawValue: "createUseCaseAlert"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(createStickFigureAlert), name: NSNotification.Name(rawValue: "createStickFigureAlert"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onRestoreLineUndoRedo(_:)), name: .restoreLineUndoRedo, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onDeletionLineUndoRedo(_:)), name: .deletionLineUndoRedo, object: nil)
    }
    
    @objc func createStickFigureAlert(sender: AnyObject) {
        let stickFigure = StickFigureView(actorName: sender.userInfo["actorName"] as! String, x: 0, y:0, height: 60 , width: 50,  index: self.shapes.count + 1,  imageID: (self.image?.id)!)
        self.shapes[stickFigure.uuid!] = stickFigure
        self.drawingPlace.addSubview(stickFigure)
        self.undoRedoManager.alertInsertion(shape: stickFigure)
        self.drawingSocketManager.addShape(shape: stickFigure, imageID: self.image!.id!)
    }
    
    
    @objc func createUseCaseAlert(sender: AnyObject) {
        self.useCaseText = sender.userInfo["useCase"] as! String
        self.useCaseTapped()
    }
    
    @objc func setColorAlert(sender: AnyObject) {
        self.setButtonColor(sender.userInfo["color"] as! UIColor)
    }
    
    @objc func relationInfoAlert(sender: AnyObject) {
        self.firstEndLabel = sender.userInfo["firstEndLabel"] as! String
        self.secondEndLabel = sender.userInfo["secondEndLabel"] as! String
        self.firstEndRelation = sender.userInfo["firstEndRelation"] as! Relation
        self.secondEndRelation = sender.userInfo["secondEndRelation"] as! Relation
        self.isUserEditingShape = true
        self.currentShape = Shape.Line
        
        if(self.drawLineAlerted) {
            self.drawLineAlertContinue()
        }
    }
    
    @objc func relationInfoCancelAlert(sender: AnyObject) {
        if(self.drawLineAlerted) {
            self.startPointView?.hideAnchorPoints()
            self.endPointView?.hideAnchorPoints()
            self.startPointView?.showAnchorPoints()
            self.endPointView?.showAnchorPoints()
        }
        self.resetLineEndPoints()
        self.redrawLayers()
        self.drawLineAlerted = false
        self.stopDrawing()
        self.resetTouchAnchorPoint()
    }
    
    @objc func createClassDiagramAlert(sender: AnyObject) {
        let text = self.processText(text: sender.userInfo["text"] as! String)
        
        let rectangle = self.resizeFrame(words: text, x: 100, y: 100, width: 200)
        let classDiagram = ClassDiagramView(text: text, x:100, y:100, height: rectangle.height, width:200, index: self.shapes.count + 1,  imageID: (self.image?.id)!)
        self.shapes[classDiagram.uuid!] = classDiagram
        self.drawingPlace.addSubview(classDiagram)
        self.undoRedoManager.alertInsertion(shape: classDiagram)
        self.drawingSocketManager.addShape(shape: classDiagram,  imageID: (self.image?.id)!)
    }
    
    func resizeFrame(words: [String], x: CGFloat, y: CGFloat, width: CGFloat) -> CGRect {
        let height = self.calculateHeight(words: words, width: width)
        let rectangle = CGRect(x: x, y: y, width: width, height: height)
        return rectangle
    }
    
    func calculateHeight(words: [String], width: CGFloat) -> CGFloat {
        var currentHeight = CGFloat(0)
        for word in words {
            let label = UILabel(frame: CGRect(x: 5, y: currentHeight, width: width - 5, height: 30))
            label.contentMode = .scaleToFill
            label.numberOfLines = 5
            label.text = word
            label.lineBreakMode = NSLineBreakMode.byWordWrapping
            
            if(currentHeight == CGFloat(0)) {
                label.textAlignment = NSTextAlignment.center
            } else {
                label.sizeToFit()
            }
            
            currentHeight += label.frame.height
        }
        
        currentHeight += 20
        
        return currentHeight
    }
    
    
    @objc func movedViewAlert(sender: AnyObject) {
        let view =  sender.userInfo["shape"] as! BasicShapeView
        self.drawingSocketManager.editShape(shape: view,  imageID: (self.image?.id)!)
        let viewUUID = view.uuid!
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
            self.drawLineAlerted = true
            self.showRelationPopover()
        }
    }
    
    func drawLineAlertContinue() {
        var bezier = UIBezierPath()
        bezier.move(to: self.startPointOfLine!)
        bezier.addLine(to: self.endPointOfLine!)
        //self.currentContext = nil
        bezier.close()
        let layer = CAShapeLayer()
        layer.path = bezier.cgPath
        layer.borderWidth = 2
        layer.strokeColor = UIColor.green.cgColor
        var line = Line(layer: layer, startPoint: self.startPointOfLine!, endPoint: self.endPointOfLine!, firstEndRelation: self.firstEndRelation!, secondEndRelation: self.secondEndRelation!, firstEndTextField: self.firstEndLabel!, secondEndTextField: self.secondEndLabel!)
        self.startPointView?.hideAnchorPoints()
        self.endPointView?.hideAnchorPoints()
        line.firstAnchorShapeId = self.startPointView?.uuid
        line.firstAnchorShapeIndex = self.startAnchorNumber
        line.secondAnchorShapeId = self.endPointView?.uuid
        line.secondAnchorShapeIndex = self.endAnchorNumber
        self.selectLine(line: line)
        self.lines.append(line)
        self.drawingPlace.layer.addSublayer(line.layer!)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "lineDrawnAlert"), object: nil)
        self.resetLineEndPoints()
        self.redrawLayers()
        self.drawLineAlerted = false
        self.stopDrawing()
    }
    
    func drawLine(line: Line) {
        line.redrawLine()
        self.currentContext = nil
        redrawLayers()
    }
    
    func selectLine(line: Line) {
        line.select()
    }
    
    func unselectLine(line: Line) {
        line.unselect()
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
            for layer in self.drawingPlace.layer.sublayers! {
                self.drawingPlace.layer.sublayers?.popLast()
            }
        }
        
        for (uuid, view) in self.shapes{
            self.drawingPlace.layer.addSublayer(view.layer)
        }
        
        for line in lines {
            self.drawingPlace.layer.addSublayer(line.layer!)
            let labels = line.addLabels()
            
            for label in labels {
                self.drawingPlace.addSubview(label)
            }
            
        }
    }
    
    
    
    func resetTouchAnchorPoint() {
        for (key, shape) in self.shapes {
            shape.touchAnchorPoint = false
        }
    }
    
    func handleSocketEmits() {
        //self.drawingSocketManager.requestJoinImage(imageId: "9db006f6-cd93-11e8-ad4f-12e4abeee048")
        //self.drawingSocketManager.requestJoinImage(imageId: "9db006f6-cd93-11e8-ad4f-12e4abeee049")
        self.drawingSocketManager.requestJoinImage(imageId: self.image!.id!)
        self.drawingSocketManager.socketIOClient.on("imageData") { (data, ack) in
            
            let dataArray = data[0] as! NSArray
            for i in 0 ..< dataArray.count {
                let dataString = dataArray[i] as! [String: AnyObject]
                
                if (dataString["ShapeType"] as! String == "RECTANGLE" || dataString["ShapeType"] as! String == "ELLIPSE"  || dataString["ShapeType"] as! String == "TRIANGLE" || dataString["ShapeType"] as! String == "USE" ) {
                    let view = self.imageLoader.parseShapes(shape: dataString,  imageID: (self.image?.id)!)
                    view?.uuid = dataString["Id"] as! String
                    self.shapes[view!.uuid!] = view
                    self.drawingPlace.addSubview(view!)
                    //self.drawingPlace.layer.addSublayer(view!.layer)
                    
                }
                    
                else if(dataString["ShapeType"] as! String == "CLASS"){
                    let classShape = self.imageLoader.parseClass(shape: dataString,  imageID: (self.image?.id)!)!
                    classShape.uuid = dataString["Id"] as! String
                    self.shapes[classShape.uuid!] = classShape
                    self.drawingPlace.addSubview(classShape)
                    //self.drawingPlace.layer.addSublayer(classShape.layer)
                }
                    
                else if(dataString["ShapeType"] as! String == "ACTOR"){
                    let actorShape = self.imageLoader.parseActor(shape: dataString,  imageID: (self.image?.id)!)!
                    actorShape.uuid = dataString["Id"] as! String
                    self.shapes[actorShape.uuid!] = actorShape
                    self.drawingPlace.addSubview(actorShape)
                    //self.drawingPlace.layer.addSublayer(actorShape.layer)
                }
                    
                else if(dataString["ShapeType"] as! String == "LINE"){
                    let line = self.imageLoader.parseLine(shape: dataString)!
                    line.uuid = dataString["Id"] as! String
                    self.lines.append(line)
                    self.drawingPlace.layer.addSublayer(line.layer!)
                    let labels = line.addLabels()
                    for label in labels {
                        self.drawingPlace.addSubview(label)
                    }
                    
                }
            }
        }
        self.drawingSocketManager.socketIOClient.on("addStroke") { (data, ack) in
            let dataString = data[0] as! [String: AnyObject]
            
            if (dataString["ShapeType"] as! String == "RECTANGLE" || dataString["ShapeType"] as! String == "ELLIPSE"  || dataString["ShapeType"] as! String == "TRIANGLE" || dataString["ShapeType"] as! String == "USE") {
                let view = self.imageLoader.parseShapes(shape: dataString,  imageID: (self.image?.id)!)
                view?.uuid = dataString["Id"] as! String
                self.shapes[view!.uuid!] = view
                self.drawingPlace.addSubview(view!)
                
            }
                
            else if(dataString["ShapeType"] as! String == "CLASS"){
                let classShape = self.imageLoader.parseClass(shape: dataString,  imageID: (self.image?.id)!)!
                classShape.uuid = dataString["Id"] as! String
                self.shapes[classShape.uuid!] = classShape
                self.drawingPlace.addSubview(classShape)
            }
                
            else if(dataString["ShapeType"] as! String == "ACTOR"){
                let actorShape = self.imageLoader.parseActor(shape: dataString, imageID: (self.image?.id)!)!
                actorShape.uuid = dataString["Id"] as! String
                self.shapes[actorShape.uuid!] = actorShape
                self.drawingPlace.addSubview(actorShape)
            }
                
            else if(dataString["ShapeType"] as! String == "LINE"){
                let line = self.imageLoader.parseLine(shape: dataString)!
                line.uuid = dataString["Id"] as! String
                self.lines.append(line)
                self.drawingPlace.layer.addSublayer(line.layer!)
                let labels = line.addLabels()
                for label in labels {
                    self.drawingPlace.addSubview(label)
                }
                
            }
        }
        
        self.drawingSocketManager.socketIOClient.on("removeStroke") { (data, ack) in
            let uuid = data[0] as! String
            let shape = self.shapes[uuid]
            shape?.removeFromSuperview()
            self.shapes.removeValue(forKey: uuid)
        }
        
        self.drawingSocketManager.socketIOClient.on("clearCanvas") { (data, ack) in
            self.deleteAllShapes()
        }
        
        self.drawingSocketManager.socketIOClient.on("editStroke") { (data, ack) in
            let dataString = data[0] as! [String: AnyObject]
            print("got it")
            if (dataString["ShapeType"] as! String == "RECTANGLE" || dataString["ShapeType"] as! String == "ELLIPSE"  || dataString["ShapeType"] as! String == "TRIANGLE" || dataString["ShapeType"] as! String == "USE") {
                let uuid = dataString["Id"] as! String
                let shape = self.shapes[uuid]
                shape?.removeFromSuperview()
                let view = self.imageLoader.parseShapes(shape: dataString,  imageID: (self.image?.id)!)
                view?.uuid = dataString["Id"] as! String
                
                self.shapes.updateValue(view!, forKey: dataString["Id"] as! String)
                self.drawingPlace.addSubview(view!)
                //let userInfo = ["shape":view!] as [String : BasicShapeView]
                //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "movedView"), object: nil, userInfo: userInfo)
            }
            if (dataString["ShapeType"] as! String == "CLASS") {
                let uuid = dataString["Id"] as! String
                let shape = self.shapes[uuid]
                shape?.removeFromSuperview()
                let view = self.imageLoader.parseClass(shape: dataString,  imageID: (self.image?.id)!)
                view?.uuid = dataString["Id"] as! String
                self.shapes.updateValue(view!, forKey: dataString["Id"] as! String)
                self.drawingPlace.addSubview(view!)
                //let userInfo = ["shape":view!] as [String : BasicShapeView]
               // NotificationCenter.default.post(name: NSNotification.Name(rawValue: "movedView"), object: nil, userInfo: userInfo)
            }
                
            if (dataString["ShapeType"] as! String == "ACTOR") {
                let uuid = dataString["Id"] as! String
                let shape = self.shapes[uuid]
                shape?.removeFromSuperview()
                let view = self.imageLoader.parseActor(shape: dataString,  imageID: (self.image?.id)!)
                view?.uuid = dataString["Id"] as! String
                self.shapes.updateValue(view!, forKey: dataString["Id"] as! String)
                self.drawingPlace.addSubview(view!)
                //let userInfo = ["shape":view!] as [String : BasicShapeView]
                // NotificationCenter.default.post(name: NSNotification.Name(rawValue: "movedView"), object: nil, userInfo: userInfo)
            }
                
            else if(dataString["ShapeType"] as! String == "LINE"){
                let line = self.imageLoader.parseLine(shape: dataString)!
                line.uuid = dataString["Id"] as! String
                self.lines.append(line)
                self.drawingPlace.layer.addSublayer(line.layer!)
                let labels = line.addLabels()
                for label in labels {
                    self.drawingPlace.addSubview(label)
                }
            }
        }
    }
    
    func showRelationPopover() {
        self.performSegue(withIdentifier: "toRelationPopover", sender: nil)
    }
    
}




