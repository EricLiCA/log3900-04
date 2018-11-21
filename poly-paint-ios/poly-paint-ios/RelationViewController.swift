//
//  RelationViewController.swift
//  poly-paint-ios
//
//  Created by Tomato on 2018-11-21.
//  Copyright © 2018 PolyAcme. All rights reserved.
//

import UIKit

class RelationViewController: UIViewController {

    @IBOutlet weak var firstEndLabel: UITextField!
    @IBOutlet weak var firstEndAssociationButton: UIButton!
    @IBOutlet weak var firstEndAggregationButton: UIButton!
    @IBOutlet weak var firstEndCompositionButton: UIButton!
    @IBOutlet weak var firstEndInheritanceButton: UIButton!
    @IBOutlet weak var firstEndArrowButton: UIButton!
    @IBOutlet weak var secondEndLabel: UITextField!
    @IBOutlet weak var secondEndAssociationButton: UIButton!
    @IBOutlet weak var secondEndAggregationButton: UIButton!
    @IBOutlet weak var secondEndCompositionButton: UIButton!
    @IBOutlet weak var secondEndInheritanceButton: UIButton!
    @IBOutlet weak var secondEndArrowButton: UIButton!
    
    var firstEndRelation: Relation?
    var secondEndRelation: Relation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.defaultRelationOptions()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func insertTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        self.sendRelationInfo()
    }
    
    @IBAction func cancelTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "relationInfoCancelAlert"), object: nil)
    }
    
    func sendRelationInfo() {
        let userInfo = ["firstEndLabel": self.firstEndLabel.text, "secondEndLabel": self.secondEndLabel.text, "firstEndRelation": self.firstEndRelation, "secondEndRelation": self.secondEndRelation] as [String : Any]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "relationInfoAlert"), object: nil, userInfo: userInfo)
        
    }
    
    @IBAction func firstEndAssociationTapped(_ sender: UIButton) {
        self.firstEndRelation = Relation.Association
        self.firstEndAssociationButton.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        self.firstEndAggregationButton.backgroundColor = UIColor.white
        self.firstEndCompositionButton.backgroundColor = UIColor.white
        self.firstEndInheritanceButton.backgroundColor = UIColor.white
        self.firstEndArrowButton.backgroundColor = UIColor.white
    }
    
    @IBAction func firstEndAggregationTapped(_ sender: UIButton) {
        self.firstEndRelation = Relation.Aggregation
        self.firstEndAssociationButton.backgroundColor = UIColor.white
        self.firstEndAggregationButton.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        self.firstEndCompositionButton.backgroundColor = UIColor.white
        self.firstEndInheritanceButton.backgroundColor = UIColor.white
        self.firstEndArrowButton.backgroundColor = UIColor.white
    }
    
    @IBAction func firstEndCompositionTapped(_ sender: UIButton) {
        self.firstEndRelation = Relation.Composition
        self.firstEndAssociationButton.backgroundColor = UIColor.white
        self.firstEndAggregationButton.backgroundColor = UIColor.white
        self.firstEndCompositionButton.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        self.firstEndInheritanceButton.backgroundColor = UIColor.white
        self.firstEndArrowButton.backgroundColor = UIColor.white
    }
    
    @IBAction func firstEndInheritanceTapped(_ sender: UIButton) {
        self.firstEndRelation = Relation.Inheritance
        self.firstEndAssociationButton.backgroundColor = UIColor.white
        self.firstEndAggregationButton.backgroundColor = UIColor.white
        self.firstEndCompositionButton.backgroundColor = UIColor.white
        self.firstEndInheritanceButton.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        self.firstEndArrowButton.backgroundColor = UIColor.white
    }
    
    @IBAction func firstEndArrowTapped(_ sender: UIButton) {
        self.firstEndRelation = Relation.Arrow
        self.firstEndAssociationButton.backgroundColor = UIColor.white
        self.firstEndAggregationButton.backgroundColor = UIColor.white
        self.firstEndCompositionButton.backgroundColor = UIColor.white
        self.firstEndInheritanceButton.backgroundColor = UIColor.white
        self.firstEndArrowButton.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    }
    
    @IBAction func secondEndAssociationTapped(_ sender: UIButton) {
        self.secondEndRelation = Relation.Association
        self.secondEndAssociationButton.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        self.secondEndAggregationButton.backgroundColor = UIColor.white
        self.secondEndCompositionButton.backgroundColor = UIColor.white
        self.secondEndInheritanceButton.backgroundColor = UIColor.white
        self.secondEndArrowButton.backgroundColor = UIColor.white
    }
    
    @IBAction func secondEndAggregationTapped(_ sender: UIButton) {
        self.secondEndRelation = Relation.Aggregation
        self.secondEndAssociationButton.backgroundColor = UIColor.white
        self.secondEndAggregationButton.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        self.secondEndCompositionButton.backgroundColor = UIColor.white
        self.secondEndInheritanceButton.backgroundColor = UIColor.white
        self.secondEndArrowButton.backgroundColor = UIColor.white
    }
    
    @IBAction func secondEndCompositionTapped(_ sender: UIButton) {
        self.secondEndRelation = Relation.Composition
        self.secondEndAssociationButton.backgroundColor = UIColor.white
        self.secondEndAggregationButton.backgroundColor = UIColor.white
        self.secondEndCompositionButton.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        self.secondEndInheritanceButton.backgroundColor = UIColor.white
        self.secondEndArrowButton.backgroundColor = UIColor.white
    }
    
    @IBAction func secondEndInheritanceTapped(_ sender: UIButton) {
        self.secondEndRelation = Relation.Inheritance
        self.secondEndAssociationButton.backgroundColor = UIColor.white
        self.secondEndAggregationButton.backgroundColor = UIColor.white
        self.secondEndCompositionButton.backgroundColor = UIColor.white
        self.secondEndInheritanceButton.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        self.secondEndArrowButton.backgroundColor = UIColor.white
    }
    
    @IBAction func secondEndArrowTapped(_ sender: UIButton) {
        self.secondEndRelation = Relation.Arrow
        self.secondEndAssociationButton.backgroundColor = UIColor.white
        self.secondEndAggregationButton.backgroundColor = UIColor.white
        self.secondEndCompositionButton.backgroundColor = UIColor.white
        self.secondEndInheritanceButton.backgroundColor = UIColor.white
        self.secondEndArrowButton.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    }
    
    func defaultRelationOptions() {
        self.resetRelationOptions()
        self.firstEndRelation = Relation.Association
        self.firstEndAssociationButton.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        self.secondEndRelation = Relation.Association
        self.secondEndAssociationButton.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    }
    
    func resetRelationOptions() {
        self.firstEndLabel.text = ""
        self.secondEndLabel.text = ""
        self.firstEndRelation = nil
        self.secondEndRelation = nil
        self.secondEndAssociationButton.backgroundColor = UIColor.white
        self.secondEndAggregationButton.backgroundColor = UIColor.white
        self.secondEndCompositionButton.backgroundColor = UIColor.white
        self.secondEndInheritanceButton.backgroundColor = UIColor.white
        self.secondEndArrowButton.backgroundColor = UIColor.white
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
