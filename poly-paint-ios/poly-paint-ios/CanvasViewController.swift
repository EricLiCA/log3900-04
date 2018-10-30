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
    case None
}

class CanvasViewController: UIViewController {

    @IBOutlet weak var squareButton: UIButton!
    @IBOutlet weak var canvasView: UIView!
    
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
                let shapeView = SquareView(origin: tapPoint)
                self.canvasView.addSubview(shapeView)
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
