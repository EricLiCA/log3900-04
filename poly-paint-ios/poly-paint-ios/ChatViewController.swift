//
//  ChatViewController.swift
//  poly-paint-ios
//
//  Created by Eric Sida Li on 2018-09-22.
//  Copyright © 2018 PolyAcme. All rights reserved.
//

import UIKit
import SocketIO
import AVFoundation
import RxSwift
import RxCocoa

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    // MARK: - View Elements
    @IBOutlet weak var messageTableView: UITableView!
    @IBOutlet weak var connectionStatus: UILabel!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var dockViewHeightConstraint: NSLayoutConstraint!
    
    // MARK: - Models
    let chatModel = ChatModel.instance
    var messagesArray = [String]()
    var serverAddress: String = SERVER.URL.rawValue
    var username: String = ""
    var invalidUsername: Bool = false
    let systemSoundID: SystemSoundID = 1016
    // MARK: Sockets
    var manager: SocketManager!
    var socketIOClient: SocketIOClient!
    
    // MARK: Observers
    
    // MARK: - Initialization and Cleanup
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ChatModel.instance.notifications = 0
        ChatModel.instance.notificationsSubject.onNext(0)
        
        messagesArray = chatModel.messagesArray
        
        // Add listeners for keyboard events
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
        
        setConnectionStatus(as: "connecting")
        
        // Set as delegate for the message table
        self.messageTableView.delegate = self
        self.messageTableView.dataSource = self
        
        // Set as delegate for the textfield
        self.messageTextField.delegate = self
        self.messageTextField.clearsOnBeginEditing = true
        
        // Initialize socket connection
        connectToSocket()
        
        // Focus on message text field + show keyboard
        messageTextField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // Hide keyboard
        messageTextField.resignFirstResponder()
        ChatModel.instance.notifications = 0
        ChatModel.instance.notificationsSubject.onNext(0)
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
    
    /*private func addToMessageTableView(message: String, sentBy username: String) {
        let newIndexPath = IndexPath(row: self.messagesArray.count, section: 0)
        let formattedMessage = "[\(currentTime())] \(username): \(message)"
        self.messagesArray.append(formattedMessage)
        self.messageTableView.insertRows(at: [newIndexPath], with: .automatic)
        self.messageTableView.scrollToRow(at: newIndexPath, at: .bottom, animated: true)
    }*/
    
    // MARK: - Server communication
    
    private func connectToSocket() {
        self.chatModel.connectionStatusSubject.asObservable().subscribe(onNext: {
            status in
            self.setConnectionStatus(as: status)
        })
        
        self.chatModel.disconnectSubject.asObservable().subscribe(onNext: {
            disconnected in
            if disconnected {
                self.navigationController?.popViewController(animated: true)
            }
        })
        
        self.chatModel.messagesSubject.asObservable().subscribe(onNext: {
            messages in
            print(messages)
            self.messagesArray = messages
            self.messageTableView.reloadData()
            //ChatModel.instance.notifications = 0
            //ChatModel.instance.notificationsSubject.onNext(0)
            /*let newIndexPath = IndexPath(row: self.messagesArray.count, section: 0)
            self.messageTableView.insertRows(at: [newIndexPath], with: .automatic)
            self.messageTableView.scrollToRow(at: newIndexPath, at: .bottom, animated: true)*/
        })
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
                if self.chatModel.socketIOClient.status == .connected {
                    self.connectionStatus.isHidden = true
                }
            }
        default:
            return
        }
    }
    
    private func sendMessage() {
        self.chatModel.sendMessage(message: messageTextField.text!)
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

