//
//  ChatViewController.swift
//  poly-paint-ios
//
//  Created by Eric Sida Li on 2018-09-22.
//  Copyright © 2018 PolyAcme. All rights reserved.
//

import UIKit
import SocketIO

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    // MARK: - View Elements
    @IBOutlet weak var messageTableView: UITableView!
    @IBOutlet weak var connectionStatus: UILabel!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var dockViewHeightConstraint: NSLayoutConstraint!
    
    // MARK: - Models
    var messagesArray = [String]()
    var serverAddress: String = "http://ec2-18-214-40-211.compute-1.amazonaws.com"
    var username: String = ""
    var invalidUsername: Bool = false
    // MARK: Sockets
    var manager: SocketManager!
    var socketIOClient: SocketIOClient!
    
    // MARK: - Initialization and Cleanup
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setConnectionStatus(as: "connecting")
        
        // Set as delegate for the message table
        self.messageTableView.delegate = self
        self.messageTableView.dataSource = self
        
        // Set as delegate for the textfield
        self.messageTextField.delegate = self
        self.messageTextField.clearsOnBeginEditing = true
        
        // Initialize socket connection
        connectToSocket()
        
        // Add listeners for keyboard events
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
        
        // Hide keyboard
        messageTextField.resignFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // Hide keyboard
        messageTextField.resignFirstResponder()
        
        socketIOClient.disconnect()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - MessageTextField
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendMessage()
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.becomeFirstResponder()
    }
    
    // MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messagesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Create a table cell
        let cell = messageTableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath)
        
        // Customize the cell
        cell.textLabel?.text = messagesArray[indexPath.row]
        
        // Return the cell
        return cell
    }
    
    private func addToMessageTableView(message: String, sentBy username: String) {
        let newIndexPath = IndexPath(row: self.messagesArray.count, section: 0)
        let formattedMessage = "[\(currentTime())] \(username): \(message)"
        self.messagesArray.append(formattedMessage)
        self.messageTableView.insertRows(at: [newIndexPath], with: .automatic)
        self.messageTableView.scrollToRow(at: newIndexPath, at: .bottom, animated: true)
    }
    
    // MARK: - Server communication
    private func connectToSocket() {
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
            guard let username = data[0] as? String else { return }
            guard let message = data[1] as? String else { return }
            self.addToMessageTableView(message: message, sentBy: username)
        }
        
        socketIOClient.on(clientEvent: SocketClientEvent.reconnect) { (data, ack) in
            self.setConnectionStatus(as: "connecting")
        }
        
        socketIOClient.connect()
    }
    
    private func setConnectionStatus(as status: String) {
        self.connectionStatus.isHidden = false
        switch status {
        case "connecting":
            self.connectionStatus.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.05428617295)
            self.connectionStatus.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            self.connectionStatus.text = self.invalidUsername ? "Username already taken! Disconnecting..." : "Connecting..."
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
    
    private func sendMessage() {
        let trimmedMessage = messageTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if (!trimmedMessage.isEmpty) {
            socketIOClient.emit("message", messageTextField.text!)
        }
        messageTextField.text = ""
    }
    
    // MARK: - Keyboard
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            moveTextDock(to: keyboardHeight)
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            moveTextDock(to: keyboardHeight)
        }
    }
    
    private func moveTextDock(to keyboardHeight: CGFloat) {
        let textBoxHeight: CGFloat = 46.0
        view.layoutIfNeeded()
        UIView.animate(withDuration: 0.15, animations: {
            self.dockViewHeightConstraint.constant = keyboardHeight + textBoxHeight
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}

