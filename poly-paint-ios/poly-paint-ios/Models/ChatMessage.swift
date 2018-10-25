//
//  ChatMessage.swift
//  poly-paint-ios
//
//  Created by Tomato on 2018-10-24.
//  Copyright © 2018 PolyAcme. All rights reserved.
//

import Foundation


struct ChatMessage {
    let text: String;
    let user: String;
    let timestamp: Int; // seconds since epoch UTC
    let sentByMyself: Bool;
}
