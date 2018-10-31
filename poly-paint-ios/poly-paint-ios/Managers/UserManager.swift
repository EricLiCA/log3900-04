//
//  UserManager.swift
//  poly-paint-ios
//
//  Created by Eric Sida Li on 2018-10-30.
//  Copyright © 2018 PolyAcme. All rights reserved.
//

import Foundation

class UserManager {
    static let instance = UserManager()
    var username = ""
    var id: String? = nil
    var token: String? = nil
    
    private init() {}
    
    func reset() {
        username = ""
        id = nil
        token = nil
    }
}
