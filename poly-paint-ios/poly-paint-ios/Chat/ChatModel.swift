//
//  ChatModel.swift
//  poly-paint-ios
//
//  Created by Eric Sida Li on 2018-11-15.
//  Copyright © 2018 PolyAcme. All rights reserved.
//

import Foundation
import SocketIO
import AVFoundation
import RxSwift

class ChatModel {
    static let instance = ChatModel()
    
    // MARK: - Models
    var messagesArray = [String]()
    var serverAddress: String = "http://localhost:3000/"
    var username: String = ""
    var invalidUsername: Bool = false
    let systemSoundID: SystemSoundID = 1016
    // MARK: Sockets
    var manager: SocketManager!
    var socketIOClient: SocketIOClient!
    
    init() {
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
            guard let username = data[1] as? String else { return }
            guard let message = data[2] as? String else { return }
            if username != "You" {
                AudioServicesPlaySystemSound (self.systemSoundID)
            }
            self.addToMessageTableView(message: message, sentBy: username)
        }
        
        socketIOClient.on(clientEvent: SocketClientEvent.reconnect) { (data, ack) in
            self.setConnectionStatus(as: "connecting")
        }
        
        socketIOClient.connect()
    }
    
    private func sendMessage(message: String) {
        let trimmedMessage = message.trimmingCharacters(in: .whitespacesAndNewlines)
        if (!trimmedMessage.isEmpty) {
            socketIOClient.emit("message", "Lobby", message)
        }
        messageTextField.text = ""
    }
    
    private func addToMessageTableView(message: String, sentBy username: String) {
        let newIndexPath = IndexPath(row: self.messagesArray.count, section: 0)
        let formattedMessage = "[\(currentTime())] \(username): \(message)"
        self.messagesArray.append(formattedMessage)
        self.messageTableView.insertRows(at: [newIndexPath], with: .automatic)
        self.messageTableView.scrollToRow(at: newIndexPath, at: .bottom, animated: true)
    }
}
