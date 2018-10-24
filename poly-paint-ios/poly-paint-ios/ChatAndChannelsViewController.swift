//
//  ChatAndChannelsViewController.swift
//  poly-paint-ios
//
//  Created by Tomato on 2018-10-24.
//  Copyright © 2018 PolyAcme. All rights reserved.
//

import UIKit


class ChannelTableViewCell: UITableViewCell {
    
    @IBOutlet weak var joinChannelButton: UIButton!
    @IBOutlet weak var channelNameLabel: UILabel!
    
    @IBOutlet weak var leaveChannelButton: UIButton!
    @IBAction func joinChannelTapped(_ sender: UIButton) {
    }
    
    @IBOutlet weak var leaveChannelTapped: UIButton!
}

class ChatAndChannelsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let myChannelsArray = ["General", "Popo", "Hello you"]
    let allChannelsArray = ["General", "Bob", "Poly", "Popo", "PolyAcme", "Hello you", "HEYYY"]
    var selectedSegment = 1
    
    @IBOutlet weak var channelsTableView: UITableView!
    @IBAction func segmentedControle(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            selectedSegment = 1
        } else {
            selectedSegment = 2
        }
        
        self.channelsTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        channelsTableView.delegate = self
        channelsTableView.dataSource = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selectedSegment == 1 {
            return myChannelsArray.count
        } else {
            return allChannelsArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        if selectedSegment == 1 {
            let cell1 = channelsTableView.dequeueReusableCell(withIdentifier: "LeaveChannelCell")! as! ChannelTableViewCell
            cell1.channelNameLabel.text = myChannelsArray[indexPath.row]
            return cell1
        } else {
            if(myChannelsArray.contains(allChannelsArray[indexPath.row])) {
                let cell2 = channelsTableView.dequeueReusableCell(withIdentifier: "LeaveChannelCell")! as! ChannelTableViewCell
                cell2.channelNameLabel.text = allChannelsArray[indexPath.row]
                return cell2
            } else {
                let cell2 = channelsTableView.dequeueReusableCell(withIdentifier: "secondCell")! as! ChannelTableViewCell
                cell2.channelNameLabel.text = allChannelsArray[indexPath.row]
                return cell2
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(selectedSegment == 1) { // My channels
            displaySelectedChannel(channel: self.myChannelsArray[indexPath.row])
        } else {
            displaySelectedChannel(channel: self.allChannelsArray[indexPath.row])
        }
    }
    
    // TODO: Display chat according to channel in embedded view
    func displaySelectedChannel(channel: String) {
        print("channel: \(channel)")
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
