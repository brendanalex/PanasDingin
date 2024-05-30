//
//  UUID.swift
//  PanasDingin Phone App
//
//  Created by Brendan Alexander Soendjojo on 26/05/24.
//

import SwiftUI
import CoreBluetooth

enum Role {
    case hider
    case seeker
}

struct RoleUUID{
    static let hider: CBUUID = CBUUID(string: "11111111-1111-1111-1111-111111111111")
    static let seeker: CBUUID = CBUUID(string: "22222222-2222-2222-2222-222222222222")
}

enum ProximityType: String {
    case start = "Press start if ready."
    case hiderFar = "No one is nearby."
    case hiderNear = "A hider is nearby."
    case hiderFound = "Hider has been found!"
    case seekerFar = "Seeker is far away."
    case seekerNear = "Seeker approaching!"
    case seekerFound = "Seeker has found you!"
}
