//
//  ChatManager.swift
//  poly-paint-ios
//
//  Created by Tomato on 2018-10-24.
//  Copyright © 2018 PolyAcme. All rights reserved.
//

import Foundation

class ChatManager {
    static let instance = ChatManager();
    let chatRooms = [String: [ChatRoom]];
    let activeUsers = set<String>();
}
