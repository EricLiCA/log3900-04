//
//  ViewController.swift
//  poly-paint-ios
//
//  Created by Eric Sida Li on 2018-09-22.
//  Copyright © 2018 PolyAcme. All rights reserved.
//

import UIKit
import SocketIO

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    @IBOutlet weak var messageTableView: UITableView!
    var messagesArray = [String]()
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var dockViewHeightConstraint: NSLayoutConstraint!
    
    var manager:SocketManager!
    
    var socketIOClient: SocketIOClient!
    
    func ConnectToSocket() {
        
        manager = SocketManager(socketURL: URL(string: "http://localhost:3000")!, config: [.log(true), .compress])
        socketIOClient = manager.defaultSocket
        
        socketIOClient.on(clientEvent: .connect) {data, ack in
            print("socket connected")
        }
        
        socketIOClient.on(clientEvent: .error) { (data, ack) in
            print(data)
            print("socket error")
        }
        
        socketIOClient.on(clientEvent: .disconnect) { (data, ack) in
            print(data)
            print("socket disconnect")
        }
        
        socketIOClient.on("message") { (data: [Any], ack) in
            print("received message")
            let newIndexPath = IndexPath(row: self.messagesArray.count, section: 0)
            self.messagesArray.append(data[1] as! String)
            self.messageTableView.insertRows(at: [newIndexPath], with: .automatic)
            print(data)
        }
        
        socketIOClient.on(clientEvent: SocketClientEvent.reconnect) { (data, ack) in
            print(data)
            print("socket reconnect")
        }
        
        socketIOClient.connect()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.messageTableView.delegate = self
        self.messageTableView.dataSource = self
        
        // Set as delegate for the textfield
        self.messageTextField.delegate = self
        self.messageTextField.clearsOnBeginEditing = true
        
        // Add some sample data so that we can see something
        ConnectToSocket()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            moveTextDock(to: keyboardHeight)
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            moveTextDock(to: keyboardHeight)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func moveTextDock(to keyboardHeight: CGFloat) {
        let textBoxHeight: CGFloat = 46.0
        view.layoutIfNeeded()
        UIView.animate(withDuration: 0.15, animations: {
            self.dockViewHeightConstraint.constant = keyboardHeight + textBoxHeight
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func sendMessage() {
        socketIOClient.emit("message", messageTextField.text!)
        messageTextField.text = ""
    }
    
    // MARK: TextField Delegate Methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendMessage()
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    // MARK: TableView Delegate Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messagesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Create a table cell
        guard let cell = messageTableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as? UITableViewCell else {
            fatalError("Could not dequeue UITableViewCell")
        }
        
        // Customize the cell
        cell.textLabel?.text = messagesArray[indexPath.row]
        
        // Return the cell
        return cell
    }
}

