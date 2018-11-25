//
//  User.swift
//
//
//  Created by Tomato on 2018-10-22.
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
