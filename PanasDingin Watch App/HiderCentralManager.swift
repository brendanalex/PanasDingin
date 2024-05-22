//
//  HiderCentralManager.swift
//  PanasDingin Watch App
//
//  Created by Brendan Alexander Soendjojo on 20/05/24.
//


import CoreBluetooth

class HiderPeripheralManager: NSObject, CBPeripheralManagerDelegate {
    var peripheralManager: CBPeripheralManager?
    var uniqueUUID: String?
    private let serviceUUID = CBUUID(string: "12345678-1234-1234-1234-123456789ABC")
    private let characteristicUUID = CBUUID(string: "87654321-4321-4321-4321-CBA987654321")
    private var characteristic: CBMutableCharacteristic?

    override init() {
        super.init()
        peripheralManager = CBPeripheralManager()
        
        peripheralManager?.delegate = self
    }

    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        if peripheral.state == .poweredOn {
            startAdvertising()
        } else {
            print("Bluetooth is not available.")
        }
    }

    private func startAdvertising() {
//        let service = CBMutableService(type: serviceUUID, primary: true)
        let service = CBMutableService()
        service.uuid = serviceUUID
//        characteristic = CBMutableCharacteristic(type: characteristicUUID, properties: .write, value: nil, permissions: .writeable)
        characteristic = CBMutableCharacteristic
        
        service.characteristics = [characteristic!]
        peripheralManager?.add(service)

        let advertisementData: [String: Any] = [
            CBAdvertisementDataServiceUUIDsKey: [serviceUUID]
        ]
        peripheralManager?.startAdvertising(advertisementData)
    }

    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest]) {
        for request in requests {
            if request.characteristic.uuid == characteristicUUID, let value = request.value, let uuidString = String(data: value, encoding: .utf8) {
                uniqueUUID = uuidString
                peripheralManager?.respond(to: request, withResult: .success)
                print("Assigned UUID: \(uniqueUUID ?? "None")")
                peripheralManager?.stopAdvertising()
            }
        }
    }
}


//import CoreBluetooth
//
//class HiderPeripheralManager: NSObject, ObservableObject, CBPeripheralManagerDelegate {
//    var peripheralManager: CBPeripheralManager?
//    var advertisedData: [String: Any]?
//    
//    override init() {
//        super.init()
//        peripheralManager = CBPeripheralManager()
//        peripheralManager?.delegate = self
//    }
//    
//    func startAdvertising() {
//        let uuid = CBUUID(string: "E8E10F08-6A49-4E37-8B2E-B14CFE8D90BC") // Replace with your generated UUID
//        advertisedData = [CBAdvertisementDataLocalNameKey: "HiderBeacon", CBAdvertisementDataServiceUUIDsKey: [uuid]]
//        peripheralManager?.startAdvertising(advertisedData)
//    }
//    
//    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
//        if peripheral.state == .poweredOn {
//            startAdvertising()
//        } else {
//            print("Bluetooth is not available.")
//        }
//    }
//}
