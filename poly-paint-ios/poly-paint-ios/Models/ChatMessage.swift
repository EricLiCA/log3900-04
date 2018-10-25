//
//  ChatMessage.swift
//  poly-paint-ios
//
//  Created by Eric Sida Li on 2018-10-23.
//  Copyright © 2018 PolyAcme. All rights reserved.
//

import Foundation

struct ChatMessage {
    let text: String;
    let user: String;
    let timestamp: Int; // seconds since epoch UTC
    let sentByMyself: Bool;
}
