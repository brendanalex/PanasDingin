//
//  UUID.swift
//  PanasDingin Watch App
//
//  Created by Brendan Alexander Soendjojo on 26/05/24.
//

import SwiftUI
import CoreBluetooth

enum Role {
    case hider
    case seeker
}

struct roleUUID{
    static let hider: CBUUID = CBUUID(string: "11111111-1111-1111-1111-111111111111")
    static let seeker: CBUUID = CBUUID(string: "22222222-2222-2222-2222-222222222222")
}



