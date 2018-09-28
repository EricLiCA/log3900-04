//
//  ViewController.swift
//  poly-paint-ios
//
//  Created by Eric Sida Li on 2018-09-22.
//  Copyright © 2018 PolyAcme. All rights reserved.
//

import UIKit
import SocketIO

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    @IBOutlet weak var messageTableView: UITableView!
    @IBOutlet weak var connectionStatus: UILabel!
    var messagesArray = [String]()
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var dockViewHeightConstraint: NSLayoutConstraint!
    var serverAddress: String = "http://localhost:3000"
    var username: String = ""
    var invalidUsername: Bool = false
    
    var manager: SocketManager!
    
    var socketIOClient: SocketIOClient!
    
    func ConnectToSocket() {
        self.setConnectionStatus(as: "connecting")
        
        manager = SocketManager(socketURL: URL(string: serverAddress)!, config: [.log(true), .compress])
        socketIOClient = manager.defaultSocket
        
        socketIOClient.on("setUsernameStatus") { (data, ack) in
            if (data[0] as! String == "Username already taken!") {
                self.invalidUsername = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    self.socketIOClient.disconnect()
                    _ = self.navigationController?.popViewController(animated: true)
                }
            } else {
                self.setConnectionStatus(as: "connected")
            }
        }
        
        socketIOClient.on(clientEvent: .connect) {data, ack in
            self.socketIOClient.emit("setUsername", self.username)
        }
        
        socketIOClient.on(clientEvent: .error) { (data, ack) in
            self.setConnectionStatus(as: "connecting")
        }
        
        socketIOClient.on(clientEvent: .disconnect) { (data, ack) in
            self.setConnectionStatus(as: "connecting")
        }
        
        socketIOClient.on("message") { (data: [Any], ack) in
            let newIndexPath = IndexPath(row: self.messagesArray.count, section: 0)
            guard let username = data[0] as? String else { return }
            guard let message = data[1] as? String else { return }
            let formattedMessage = "[\(self.currentTime())] \(username): \(message)"
            self.messagesArray.append(formattedMessage)
            self.messageTableView.insertRows(at: [newIndexPath], with: .automatic)
            self.messageTableView.scrollToRow(at: newIndexPath, at: .bottom, animated: true)
        }
        
        socketIOClient.on(clientEvent: SocketClientEvent.reconnect) { (data, ack) in
            self.setConnectionStatus(as: "connecting")
        }
        
        socketIOClient.connect()
    }
    
    func setConnectionStatus(as status: String) {
        self.connectionStatus.isHidden = false
        switch status {
        case "connecting":
            self.connectionStatus.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.05428617295)
            self.connectionStatus.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            self.connectionStatus.text = self.invalidUsername ? "Invalid username! Disconnecting..." : "Connecting..."
        case "connected":
            self.connectionStatus.backgroundColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
            self.connectionStatus.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            self.connectionStatus.text = "Connected"
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                if self.socketIOClient.status == .connected {
                    self.connectionStatus.isHidden = true
                }
            }
        default:
            return
        }
    }
    
    func currentTime() -> String {
        let date = Date()
        let calendar = Calendar.current
        let hour = String(format: "%02d", calendar.component(.hour, from: date))
        let minutes = String(format: "%02d", calendar.component(.minute, from: date))
        let seconds = String(format: "%02d", calendar.component(.second, from: date))
        return "\(hour):\(minutes):\(seconds)"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setConnectionStatus(as: "connecting")
        self.messageTableView.delegate = self
        self.messageTableView.dataSource = self
        
        // Set as delegate for the textfield
        self.messageTextField.delegate = self
        self.messageTextField.clearsOnBeginEditing = true
        
        // Add some sample data so that we can see something
        ConnectToSocket()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
        
        messageTextField.resignFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        messageTextField.resignFirstResponder()
        socketIOClient.disconnect()
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
        let trimmedMessage = messageTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if (!trimmedMessage.isEmpty) {
            socketIOClient.emit("message", messageTextField.text!)
        }
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

