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
            
            self.prevImage?.draw(in: self.drawingPlace.bounds)
            
            let bezier = UIBezierPath()
            
            bezier.move(to: startTouch!)
            bezier.addLine(to: secondTouch!)
            bezier.close()
            
            
            UIColor.blue.set()
            
            self.currentContext?.setLineWidth(4)
            self.currentContext?.addPath(bezier.cgPath)
            self.currentContext?.strokePath()
            let img2 = self.currentContext?.makeImage()
            drawingPlace.image = UIImage.init(cgImage: img2!)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.currentContext = nil
        self.prevImage = self.drawingPlace.image
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
