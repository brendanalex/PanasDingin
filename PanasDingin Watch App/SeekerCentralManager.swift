//
//  SeekerCentralManager.swift
//  PanasDingin Watch App
//
//  Created by Brendan Alexander Soendjojo on 20/05/24.
//

import Foundation
import CoreBluetooth
import WatchKit


class SeekerCentralManager: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    var centralManager: CBCentralManager?
    @Published var proximityText: String = "Searching for hiders..."
    //    @Published var allPeri: [CBPeripheral] = []
    @Published var searching: Bool = false
    @Published var peripheralProximities: [CBPeripheral: NSNumber] = [:]
    private var assignedUUIDs: [String: CBPeripheral] = [:]
    private var predefinedUUIDs: [String] = [
        "E8E10F08-6A49-4E37-8B2E-B14CFE8D90BC",
        "A4D45F21-1C36-4D2F-9B29-A107B3575A94",
        "B6C61A1D-2B45-48A8-9C7A-25A7F0BC5F60",
        "C1D7D9A2-5E17-4C7F-9532-B2E9BB7F11A7",
        "D3E55A56-3F89-4D73-8EF3-E7F3A63F1F98",
        "E4F67B83-9C0E-4E54-B5B6-2B8FC8435A21",
        "F5A78CB4-0D6A-4911-9C1C-D9CFA3C6F4B2",
        "A8D4B63E-2E92-414A-8A98-C3A1B3C5E4C1",
        "B9E82C47-4FA4-4D34-9A7C-E4B9D5C3A2B3",
        "C0D47A65-3BA1-41E9-81A7-F3A6C2D4B3A5"
    ]
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
        // Mendelegasikan fungsi di dalam class yang merupakan fungsi-fungsi template/kosong
    }
    
    func startScanning() {
        searching = true
        let uuid = CBUUID(string: "12345678-1234-1234-1234-123456789ABC")
        centralManager?.scanForPeripherals(withServices: [uuid], options: [CBCentralManagerScanOptionAllowDuplicatesKey: true])
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            print("Ready for seeking.")
            //            startScanning()
        } else {
            print("Bluetooth is not available.")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        //        if !allPeri.contains(peripheral){
        //            allPeri.append(peripheral)
        //        }
        peripheral.delegate = self
        centralManager?.connect(peripheral, options: nil)
        
        peripheralProximities[peripheral] = RSSI
        DispatchQueue.main.async {
            self.updateProximityText()
        }
    }
    
    func updateProximityText() {
        // Check for the nearest RSSI value
        if let nearestRSSI = peripheralProximities.values.min(by: { abs($0.intValue) < abs($1.intValue) }) {
            let proximity = calculateProximity(RSSI: nearestRSSI)
            self.proximityText = proximity
        }
    }
    
    func calculateProximity(RSSI: NSNumber) -> String {
        let rssiValue = RSSI.intValue
        print(rssiValue)
        switch rssiValue {
        case let x where x >= -30:
            return "A player is very close!"
        case let x where x >= -120:
            return "A player is nearby"
        default:
            return "No Player is nearby"
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
           peripheral.discoverServices([CBUUID(string: "12345678-1234-1234-1234-123456789ABC")])
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
       guard let services = peripheral.services else { return }
       for service in services {
           peripheral.discoverCharacteristics([CBUUID(string: "87654321-4321-4321-4321-CBA987654321")], for: service)
       }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
       guard let characteristics = service.characteristics else { return }
       for characteristic in characteristics {
           if characteristic.properties.contains(.write) {
               assignUUID(to: peripheral, characteristic: characteristic)
           }
       }
    }

    private func assignUUID(to peripheral: CBPeripheral, characteristic: CBCharacteristic) {
       guard let uuid = predefinedUUIDs.first(where: { !assignedUUIDs.keys.contains($0) }) else {
           print("No available UUIDs")
           return
       }
       assignedUUIDs[uuid] = peripheral
       if let data = uuid.data(using: .utf8) {
           peripheral.writeValue(data, for: characteristic, type: .withResponse)
       }
    }
}
