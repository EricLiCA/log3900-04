//
//  ChatManager.swift
//  poly-paint-ios
//
//  Created by Tomato on 2018-10-24.
//  Copyright © 2018 PolyAcme. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ChatManager {
    static let instance = ChatManager();
    let chatRooms = [String: [ChatRoom]]();
    let activeUsers = Set<String>();
    private let channelUpdate = PublishSubject<String>()
    let currentChannel: Observable<String>?
    
    func triggerChannelUpdate(newValue: String) {
        channelUpdate.onNext(newValue)
    }
    
    private init() {
        currentChannel = channelUpdate.share(replay: 1)
    }
}
