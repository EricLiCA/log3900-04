//
//  chatManager.swift
//  poly-paint-ios
//
//  Created by Tomato on 2018-10-24.
//  Copyright © 2018 PolyAcme. All rights reserved.
//

import Foundation


class ChatManager {
    
    // Add property for socket
    var serverAddress: String = "http://ec2-18-214-40-211.compute-1.amazonaws.com"
    // MARK: Sockets
    var manager: SocketManager!
    var socketIOClient: SocketIOClient!
    
    
    class var sharedInstance: ChatManager {
        struct Singleton { static let instance = ChatManager() }
        return Singleton.instance
    }
    
    init() {
        // Create the socket
        self.control_socket = connectToServer(atAddress: self.address, atPort: self.port)
        
    }
    
    func sendMessage(message: String) {
        // Push the message onto the socket
        _ = write(self.control_socket, message, message.characters.count)
    }
    
    // Delegate methods
    
    func messageReceived(message: String) {
        
        // Emit the message using NSNotificationCenter
    }
    
    
}
