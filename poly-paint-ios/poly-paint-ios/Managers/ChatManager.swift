//
//  ChatManager.swift
//  poly-paint-ios
//
//  Created by Eric Sida Li on 2018-10-23.
//  Copyright © 2018 PolyAcme. All rights reserved.
//

import Foundation

class ChatManager {
    static let instance = ChatManager();
    let chatRooms = [String: [ChatRoom]]();
    let activeUsers = Set<String>();
}
