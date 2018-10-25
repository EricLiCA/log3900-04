//
//  User.swift
//  poly-paint-ios
//
//  Created by Tomato on 2018-10-18.
//  Copyright © 2018 PolyAcme. All rights reserved.
//

import Foundation

class User: Hashable, Equatable {
    
    var id: String = ""
    var username: String = ""
    var profilePictureUrl: String = ""
    var hashValue: Int {
        return id.hashValue;
    }
    
    init(id: String, username: String, profilePictureUrl: String) {
        self.id = id
        self.username = username
        self.profilePictureUrl = profilePictureUrl
    }
    
    static func==(lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id;
    }
    
}
