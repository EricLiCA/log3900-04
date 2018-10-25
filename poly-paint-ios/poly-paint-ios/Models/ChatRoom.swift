//
//  ChatRoom.swift
//  poly-paint-ios
//
//  Created by Eric Sida Li on 2018-10-23.
//  Copyright © 2018 PolyAcme. All rights reserved.
//

import Foundation

struct ChatRoom {
    let roomName: String;
    let users: Set<User>;
    let messages: [ChatMessage];
}
