//
//  TutorialTableViewController.swift
//  poly-paint-ios
//
//  Created by Eric Sida Li on 2018-11-28.
//  Copyright © 2018 PolyAcme. All rights reserved.
//

import UIKit
import SwiftGifOrigin

class TutorialTableViewController: UITableViewController {
    let tutorialsTitles: [String] = ["Create public image", "Create protected image", "Insert shapes", "Connect shapes at anchor points", "You can break lines into sub-lines", "You can connect any of these shapes", "You can delete a shape by long pressing", "You can duplicate a shape by long pressing", "You can add colors to the shapes"]
    let tutorialGifs: [String] = ["create_public_image", "create_protected_image", "insert_shapes", "anchor_points", "moving_lines_around", "shapes_that_have_anchors", "delete_shape", "duplicate_shape", "change_color"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tutorialsTitles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TutorialCell", for: indexPath) as! TutorialTableViewCell
        
        // Configure the cell...
        cell.tutorialDescription.setTitle(tutorialsTitles[indexPath.item], for: .normal)
        cell.tutorialDescription.tag = indexPath.item
        
        return cell
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        let destinationViewController = segue.destination as! TutorialViewController
        let button = sender as! UIButton
        let index = button.tag
        // Pass the selected object to the new view controller.
        let gifURL = tutorialGifs[index]
        destinationViewController.imageURL = gifURL
    }
    
}
