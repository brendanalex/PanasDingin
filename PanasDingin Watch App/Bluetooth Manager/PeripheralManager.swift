//
//  HiderPeripheralManager.swift
//  PanasDingin Watch App
//
//  Created by Brendan Alexander Soendjojo on 20/05/24.
//

import CoreBluetooth

class PeripheralManager: NSObject, ObservableObject, CBPeripheralManagerDelegate {
    var peripheralManager: CBPeripheralManager?
    var advertisedData: [String: Any]?
    
    override init() {
        super.init()
        peripheralManager = CBPeripheralManager()
        peripheralManager?.delegate = self
    }
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        if peripheral.state == .poweredOn {
            print("Bluetooth for peripheral is available.")
        } else {
            print("Bluetooth for peripheral is not available.")
        }
    }
    
    func startAdvertising(role: Role) {
        var uuid: CBUUID?
        
        switch role{
        case .hider:
            uuid = roleUUID.hider
        case .seeker:
            uuid = roleUUID.seeker
        }
        
        advertisedData = [CBAdvertisementDataLocalNameKey: "Beacon", CBAdvertisementDataServiceUUIDsKey: [uuid]]
        peripheralManager?.startAdvertising(advertisedData)
    }
    
    func stopAdvertising() {
        peripheralManager?.stopAdvertising()
    }
}
