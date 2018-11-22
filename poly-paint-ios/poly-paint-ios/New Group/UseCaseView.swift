//
//  UseCaseView.swift
//  poly-paint-ios
//
//  Created by Tomato on 2018-11-14.
//  Copyright © 2018 PolyAcme. All rights reserved.
//

import UIKit

class UseCaseView: EllipseView {

    var text = String()
    let textGap: CGFloat = 5
    let defaultTextLineHeight: CGFloat = 40
    let defaultMaxNumOfLines = 5
    
    init(frame: CGRect, text: String) {
        self.text = text
        super.init(frame:frame, color: UIColor.white, useCase: "")
        self.backgroundColor = UIColor.clear
        self.initGestureRecognizers()
    }
    
    // We need to implement init(coder) to avoid compilation errors
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initializeTextField() {
        let label = UILabel(frame: CGRect(x: self.textGap, y: 0, width: self.frame.width - self.textGap, height: self.defaultTextLineHeight))
        label.contentMode = .scaleToFill
        label.numberOfLines = self.defaultMaxNumOfLines
        label.text = self.text
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        self.addSubview(label)
    }

}

class useCasePopoverView: UIView {
    
    @IBOutlet weak var rawText: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.rawText.text = "Enter use case here"
    }
    
    @IBAction func createUseCaseTapped(_ sender: UIButton) {
        self.sendCreateUseCaseNotification()
    }
    
    func sendCreateUseCaseNotification() {
        let userInfo = [ "text" : rawText.text! ]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "createUseCaseAlert"), object: nil, userInfo: userInfo)
    }
}
