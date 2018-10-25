//
//  ChatRoom.swift
//  poly-paint-ios
//
//  Created by Tomato on 2018-10-24.
//  Copyright © 2018 PolyAcme. All rights reserved.
//

import Foundation

struct ChatRoom {
    let roomName: String;
    let users: Set<User>;
    let messages: [ChatMessage];
}
