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
    var messagesSubject: BehaviorSubject<[String]>
    var connectionStatusSubject: BehaviorSubject<String>
    var disconnectSubject: BehaviorSubject<Bool>
    var serverAddress: String = "http://localhost:3000/"
    var username: String = ""
    var invalidUsername: Bool = false
    let systemSoundID: SystemSoundID = 1016
    // MARK: Sockets
    var manager: SocketManager!
    var socketIOClient: SocketIOClient!
    
    private init() {
        messagesSubject = BehaviorSubject<[String]>(value: [String]())
        connectionStatusSubject = BehaviorSubject<String>(value: "connecting")
        disconnectSubject = BehaviorSubject<Bool>(value: false)
        // self.setConnectionStatus(as: "connecting")
        
        manager = SocketManager(socketURL: URL(string: serverAddress)!, config: [.log(true), .compress])
        socketIOClient = manager.defaultSocket
        
        socketIOClient.on("setUsernameStatus") { (data, ack) in
            if (data[0] as! String == "Username already taken!") {
                self.invalidUsername = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    self.socketIOClient.disconnect()
                    self.disconnectSubject.onNext(true)
                    //_ = self.navigationController?.popViewController(animated: true)
                }
            } else {
                self.connectionStatusSubject.onNext("connected")
                self.disconnectSubject.onNext(false)
                //self.setConnectionStatus(as: "connected")
            }
        }
        
        socketIOClient.on(clientEvent: .error) { (data, ack) in
            self.connectionStatusSubject.onNext("connecting")
            //self.setConnectionStatus(as: "connecting")
        }
        
        socketIOClient.on(clientEvent: .disconnect) { (data, ack) in
            self.connectionStatusSubject.onNext("connecting")
            //self.setConnectionStatus(as: "connecting")
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
            self.connectionStatusSubject.onNext("connecting")
            //self.setConnectionStatus(as: "connecting")
        }
        
        socketIOClient.connect()
    }
    
    func setUsername(username: String) {
        self.username = username
        self.socketIOClient.emit("setUsername", self.username)
    }
    
    func sendMessage(message: String) {
        let trimmedMessage = message.trimmingCharacters(in: .whitespacesAndNewlines)
        if (!trimmedMessage.isEmpty) {
            socketIOClient.emit("message", "Lobby", message)
        }
        //messageTextField.text = ""
    }
    
    private func addToMessageTableView(message: String, sentBy username: String) {
        //let newIndexPath = IndexPath(row: self.messagesArray.count, section: 0)
        let formattedMessage = "[\(currentTime())] \(username): \(message)"
        self.messagesArray.append(formattedMessage)
        self.messagesSubject.onNext(self.messagesArray)
        /*self.messageTableView.insertRows(at: [newIndexPath], with: .automatic)
        self.messageTableView.scrollToRow(at: newIndexPath, at: .bottom, animated: true)*/
    }
}
