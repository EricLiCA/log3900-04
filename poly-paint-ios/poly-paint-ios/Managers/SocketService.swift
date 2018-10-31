//
//  SocketManager.swift
//  poly-paint-ios
//
//  Created by Eric Sida Li on 2018-10-25.
//  Copyright © 2018 PolyAcme. All rights reserved.
//

import Foundation
import SocketIO

class SocketService {
    static let instance = SocketService();
    var serverAddress: String = "http://localhost:3000"
    // MARK: Sockets
    let manager: SocketManager!
    let socketIOClient: SocketIOClient!
    
    private init() {
        manager = SocketManager(socketURL: URL(string: serverAddress)!, config: [.log(true), .compress])
        socketIOClient = manager.defaultSocket
        socketIOClient.connect()
    }
}
