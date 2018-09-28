//
//  DateTime.swift
//  poly-paint-ios
//
//  Created by Eric Sida Li on 2018-09-28.
//  Copyright © 2018 PolyAcme. All rights reserved.
//

import Foundation

func currentTime() -> String {
    let date = Date()
    let calendar = Calendar.current
    let hour = String(format: "%02d", calendar.component(.hour, from: date))
    let minutes = String(format: "%02d", calendar.component(.minute, from: date))
    let seconds = String(format: "%02d", calendar.component(.second, from: date))
    return "\(hour):\(minutes):\(seconds)"
}
