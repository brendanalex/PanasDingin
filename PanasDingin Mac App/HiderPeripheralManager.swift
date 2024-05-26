//
//  HiderPeripherakManager.swift
//  PanasDingin Mac App
//
//  Created by Brendan Alexander Soendjojo on 26/05/24.
//

import CoreBluetooth
import SwiftUI

class HiderPeripheralManager: NSObject, ObservableObject, CBPeripheralManagerDelegate {
    var peripheralManager: CBPeripheralManager?
    var advertisedData: [String: Any]?
    @Published var didAdvertised: Bool = false
    
    override init() {
        super.init()
        peripheralManager = CBPeripheralManager()
        peripheralManager?.delegate = self
    }
    
    func startAdvertising() {
        let uuid = CBUUID(string: "11111111-1111-1111-1111-111111111111") // Replace with your generated UUID
        advertisedData = [CBAdvertisementDataLocalNameKey: "HiderBeacon", CBAdvertisementDataServiceUUIDsKey: [uuid]]
        peripheralManager?.startAdvertising(advertisedData)
    }
    
    func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: (any Error)?) {
        if error == nil {
            didAdvertised = true
            print("Advertising started successfully.")
        } else {
            didAdvertised = false
            print("Failed to start advertising: \(String(describing: error?.localizedDescription))")
        }
    }
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        if peripheral.state == .poweredOn {
            startAdvertising()
        } else {
            print("Bluetooth is not available.")
        }
    }
}


