//
//  User.swift
//  poly-paint-ios
//
//  Created by Tomato on 2018-10-18.
//  Copyright © 2018 PolyAcme. All rights reserved.
//

import Foundation

class User {
    
    var id: String = ""
    var username: String = ""
    var profilePictureUrl: String = ""
    
    init(id: String, username: String, profilePictureUrl: String) {
        self.id = id
        self.username = username
        self.profilePictureUrl = profilePictureUrl
    }
    
}
