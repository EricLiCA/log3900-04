//
//  SocketIOManager.swift
//  poly-paint-ios
//
//  Created by Eric Sida Li on 2018-09-24.
//  Copyright © 2018 PolyAcme. All rights reserved.
//

import Foundation
import SocketIO

class SocketIOManager {
    static let shared = SocketIOManager()
    var socket: SocketIOClient
    
    init() {
        let manager = SocketManager(socketURL: URL(string: "http://localhost:3000")!, config: [.log(true), .compress])
        socket = manager.defaultSocket
    }
    
    func establishConnection() {
        socket.connect()
    }
    
    func closeConnection() {
        socket.disconnect()
    }
}
