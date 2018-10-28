//
//  DrawViewController.swift
//  poly-paint-ios
//
//  Created by Tomato on 2018-10-25.
//  Copyright © 2018 PolyAcme. All rights reserved.
//

import UIKit

class DrawViewController: UIViewController {

    @IBOutlet weak var drawingPlace: UIImageView!
    
    var startTouch : CGPoint?
    var secondTouch : CGPoint?
    var currentContext : CGContext?
    var prevImage : UIImage?
    var lines = [Line]()
    var currentLineStartPoint: CGPoint?
    var currentLineEndPoint: CGPoint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clearTapped(_ sender: UIButton) {
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        startTouch = touch?.location(in: drawingPlace)
        self.currentLineStartPoint = startTouch
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
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
            
            /*let bezier = UIBezierPath()
            bezier.move(to: startTouch!)
            //bezier.addLine(to: secondTouch!)
            bezier.addLine(to: CGPoint(x: (secondTouch?.x)!, y: (startTouch?.y)!))
            var currentTouch = CGPoint(x: (secondTouch?.x)!, y: (startTouch?.y)!)
            bezier.move(to:currentTouch)
            bezier.addLine(to: CGPoint(x: (secondTouch?.x)!, y: (secondTouch?.y)!))
            bezier.move(to:secondTouch!)
            bezier.addLine(to: CGPoint(x: (startTouch?.x)!, y: (secondTouch?.y)!))
            bezier.move(to:CGPoint(x: (startTouch?.x)!, y: (secondTouch?.y)!))
            bezier.addLine(to: CGPoint(x: (startTouch?.x)!, y: (startTouch?.y)!))
            
            // For rectangle
            
            
            bezier.close()*/
            
            //let bezier = self.drawRectangle(startPoint: startTouch!, secondPoint: secondTouch!)
            let bezier = self.drawCircle(startPoint: startTouch!, secondPoint: secondTouch!)
            
            UIColor.blue.set()
            
            self.currentContext?.setLineWidth(4)
            self.currentContext?.addPath(bezier.cgPath)
            self.currentContext?.strokePath()
            let img2 = self.currentContext?.makeImage()
            drawingPlace.image = UIImage.init(cgImage: img2!)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        self.currentLineEndPoint = touch?.location(in: drawingPlace)
        
        self.currentContext = nil
        self.prevImage = self.drawingPlace.image
        self.addToLines()
    }
    
    func addToLines() {
        lines.append(Line(start: self.currentLineStartPoint!, end: self.currentLineEndPoint!))
    }
    
    func drawRectangle(startPoint: CGPoint, secondPoint: CGPoint) -> UIBezierPath {
        let bezier = UIBezierPath()
        bezier.move(to: startPoint)
        //bezier.addLine(to: secondTouch!)
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
        //let bezier = UIBezierPath()
        //bezier.move(to: startPoint)
        //bezier.addLine(to: secondTouch!)
        let radius = distance(startPoint, secondPoint)/2
        let center = CGPoint(x: startPoint.x+secondPoint.x/2, y: startPoint.y+secondPoint.y/2)
        //bezier.addArc(withCenter: center, radius: radius, startAngle: 0, endAngle: .pi*2, clockwise: true)
        let bezier = UIBezierPath(ovalIn: CGRect(x: startPoint.x, y: startPoint.y, width:secondPoint.x - startPoint.x, height: secondPoint.y - startPoint.y))
        
        bezier.close()
        
        return bezier
    }
    
    func drawCircle(startPoint: CGPoint, secondPoint: CGPoint) -> UIBezierPath {
        //let bezier = UIBezierPath()
        //bezier.move(to: startPoint)
        //bezier.addLine(to: secondTouch!)
        let radius = distance(startPoint, secondPoint)/2
        let center = CGPoint(x: startPoint.x+secondPoint.x/2, y: startPoint.y+secondPoint.y/2)
        //bezier.addArc(withCenter: center, radius: radius, startAngle: 0, endAngle: .pi*2, clockwise: true)
        let bezier = UIBezierPath(ovalIn: CGRect(x: startPoint.x, y: startPoint.y, width:secondPoint.x - startPoint.x, height: secondPoint.x - startPoint.x))
        
        bezier.close()
        
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
