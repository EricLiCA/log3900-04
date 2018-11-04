//
//  CanvasViewController.swift
//  poly-paint-ios
//
//  Created by Tomato on 2018-10-30.
//  Copyright © 2018 PolyAcme. All rights reserved.
//

import UIKit

enum ShapeType {
    case Square
    case Rectangle
    case Ellipse
    case Circle
    case Triangle
    case None
}

class CanvasViewController: UIViewController {

    @IBOutlet weak var squareButton: UIButton!
    @IBOutlet weak var rectangleButton: UIButton!
    @IBOutlet weak var ellipseButton: UIButton!
    @IBOutlet weak var circleButton: UIButton!
    @IBOutlet weak var canvasView: UIView!
    @IBOutlet weak var triangleButton: UIButton!
    var shapeType = ShapeType.None
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(didTap(tapGR:)))
        self.view.addGestureRecognizer(tapGR)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @objc func didTap(tapGR: UITapGestureRecognizer) {
        if(self.canvasView.frame.contains(tapGR.location(in: self.view))) {
            if(self.shapeType == ShapeType.Square) {
                let tapPoint = tapGR.location(in: self.canvasView)
                //let shapeView = SquareView(origin: tapPoint)
                //self.canvasView.addSubview(shapeView)
                //print(shapeView.uuid)
            } else if (self.shapeType == ShapeType.Rectangle) {
                let tapPoint = tapGR.location(in: self.canvasView)
                //let shapeView = RectangleView(origin: tapPoint)
                //self.canvasView.addSubview(shapeView)
            } else if (self.shapeType == ShapeType.Ellipse) {
                let tapPoint = tapGR.location(in: self.canvasView)
                //let shapeView = EllipseView(origin: tapPoint)
                //self.canvasView.addSubview(shapeView)
            } else if (self.shapeType == ShapeType.Circle) {
                let tapPoint = tapGR.location(in: self.canvasView)
                //let shapeView = CircleView(origin: tapPoint)
                //self.canvasView.addSubview(shapeView)
            } else if (self.shapeType == ShapeType.Triangle) {
                let tapPoint = tapGR.location(in: self.canvasView)
                //let shapeView = TriangleView(origin: tapPoint)
                //self.canvasView.addSubview(shapeView)
            }
        }
        
    }
    
    @IBAction func squareTapped(_ sender: UIButton) {
        if(self.shapeType == ShapeType.Square) {
            self.shapeType = ShapeType.None
            self.squareButton.backgroundColor = #colorLiteral(red: 0, green: 0.4352941176, blue: 1, alpha: 1)
        } else {
            self.shapeType = ShapeType.Square
            self.squareButton.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            self.rectangleButton.backgroundColor = #colorLiteral(red: 0, green: 0.4352941176, blue: 1, alpha: 1)
            self.ellipseButton.backgroundColor = #colorLiteral(red: 0, green: 0.4352941176, blue: 1, alpha: 1)
            self.circleButton.backgroundColor = #colorLiteral(red: 0, green: 0.4352941176, blue: 1, alpha: 1)
            self.triangleButton.backgroundColor = #colorLiteral(red: 0, green: 0.4352941176, blue: 1, alpha: 1)
        }
    }
    
    
    @IBAction func rectangleTapped(_ sender: UIButton) {
        if(self.shapeType == ShapeType.Rectangle) {
            self.shapeType = ShapeType.None
            self.rectangleButton.backgroundColor = #colorLiteral(red: 0, green: 0.4352941176, blue: 1, alpha: 1)
        } else {
            self.shapeType = ShapeType.Rectangle
            self.rectangleButton.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            self.squareButton.backgroundColor = #colorLiteral(red: 0, green: 0.4352941176, blue: 1, alpha: 1)
            self.ellipseButton.backgroundColor = #colorLiteral(red: 0, green: 0.4352941176, blue: 1, alpha: 1)
            self.circleButton.backgroundColor = #colorLiteral(red: 0, green: 0.4352941176, blue: 1, alpha: 1)
            self.triangleButton.backgroundColor = #colorLiteral(red: 0, green: 0.4352941176, blue: 1, alpha: 1)
        }
    }
    
    @IBAction func ellipseTapped(_ sender: UIButton) {
        if(self.shapeType == ShapeType.Ellipse) {
            self.shapeType = ShapeType.None
            self.ellipseButton.backgroundColor = #colorLiteral(red: 0, green: 0.4352941176, blue: 1, alpha: 1)
        } else {
            self.shapeType = ShapeType.Ellipse
            self.ellipseButton.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            self.squareButton.backgroundColor = #colorLiteral(red: 0, green: 0.4352941176, blue: 1, alpha: 1)
            self.rectangleButton.backgroundColor = #colorLiteral(red: 0, green: 0.4352941176, blue: 1, alpha: 1)
            self.circleButton.backgroundColor = #colorLiteral(red: 0, green: 0.4352941176, blue: 1, alpha: 1)
            self.triangleButton.backgroundColor = #colorLiteral(red: 0, green: 0.4352941176, blue: 1, alpha: 1)
        }
    }
    
    @IBAction func circleButton(_ sender: UIButton) {
        if(self.shapeType == ShapeType.Circle) {
            self.shapeType = ShapeType.None
            self.circleButton.backgroundColor = #colorLiteral(red: 0, green: 0.4352941176, blue: 1, alpha: 1)
        } else {
            self.shapeType = ShapeType.Circle
            self.circleButton.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            self.squareButton.backgroundColor = #colorLiteral(red: 0, green: 0.4352941176, blue: 1, alpha: 1)
            self.rectangleButton.backgroundColor = #colorLiteral(red: 0, green: 0.4352941176, blue: 1, alpha: 1)
            self.ellipseButton.backgroundColor = #colorLiteral(red: 0, green: 0.4352941176, blue: 1, alpha: 1)
            self.triangleButton.backgroundColor = #colorLiteral(red: 0, green: 0.4352941176, blue: 1, alpha: 1)
        }
    }
    
    @IBAction func triangleTapped(_ sender: Any) {
        if(self.shapeType == ShapeType.Triangle) {
            self.shapeType = ShapeType.None
            self.triangleButton.backgroundColor = #colorLiteral(red: 0, green: 0.4352941176, blue: 1, alpha: 1)
        } else {
            self.shapeType = ShapeType.Triangle
            self.triangleButton.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            self.squareButton.backgroundColor = #colorLiteral(red: 0, green: 0.4352941176, blue: 1, alpha: 1)
            self.rectangleButton.backgroundColor = #colorLiteral(red: 0, green: 0.4352941176, blue: 1, alpha: 1)
            self.ellipseButton.backgroundColor = #colorLiteral(red: 0, green: 0.4352941176, blue: 1, alpha: 1)
            self.circleButton.backgroundColor = #colorLiteral(red: 0, green: 0.4352941176, blue: 1, alpha: 1)
        }
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
