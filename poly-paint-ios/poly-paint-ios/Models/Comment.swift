//
//  Comment.swift
//  poly-paint-ios
//
//  Created by Eric Sida Li on 2018-11-26.
//  Copyright © 2018 PolyAcme. All rights reserved.
//

import Foundation

class Comment {
    var comment: String
    var username: String
    var timestamp: String
    
    init(username: String, comment: String, timestamp: String) {
        self.comment = comment
        self.username = username
        self.timestamp = timestamp
    }
}
