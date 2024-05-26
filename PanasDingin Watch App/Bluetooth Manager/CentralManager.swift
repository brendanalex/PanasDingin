//
//  SeekerCentralManager.swift
//  PanasDingin Watch App
//
//  Created by Brendan Alexander Soendjojo on 20/05/24.
//

import Foundation
import CoreBluetooth
import AVFoundation
import WatchKit

class CentralManager: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    var centralManager: CBCentralManager?
    var peripheralManager: PeripheralManager?
    var currentRole: Role?
    private var lastRSSICheckTime: Date?
    var audioPlayer: AVAudioPlayer?
    @Published var proximityText: String = "Press start if ready."
    @Published var searching: Bool = false
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            print("Bluetooth for central is available.")
        } else {
            print("Bluetooth for central is not available.")
        }
    }
    
    func startScanning(role: Role) {
        searching = true
        var uuid: CBUUID?
        
        switch role{
        case .hider:
            uuid = roleUUID.seeker
            currentRole = .hider
        case .seeker:
            uuid = roleUUID.hider
            currentRole = .seeker
        }
        
        centralManager?.scanForPeripherals(withServices: [uuid!], options: [CBCentralManagerScanOptionAllowDuplicatesKey: true])
    }
    
    func stopScanning() {
        searching = false
        centralManager?.stopScan()
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if shouldUpdateProximity(){
            handleProximity(RSSI: RSSI)
        }
    }
    
    private func shouldUpdateProximity() -> Bool {
        let now = Date()
        if let lastCheck = lastRSSICheckTime {
            if now.timeIntervalSince(lastCheck) >= 1 {
                lastRSSICheckTime = now
                return true
            } else {
                return false
            }
        } else {
            lastRSSICheckTime = now
            return true
        }
    }
    
    func handleProximity(RSSI: NSNumber) {
        let rssiValue = RSSI.intValue
        var proximity: String?
        let device = WKInterfaceDevice.current()
        
        print(rssiValue)
        
        if currentRole == .hider {
            switch rssiValue {
            case let x where x >= -60:
                proximity = "Seeker has found you!"
                playSound(fileName: "Lose", fileType: "mp3")
                stopScanning()
                peripheralManager?.stopAdvertising()
            case let x where x >= -100:
                proximity = "Seeker is approaching!"
                device.play(.click)
            default:
                proximity = "Seeker is far away."
                device.play(.directionUp)
            }
        } else if currentRole == .seeker {
            switch rssiValue {
            case let x where x >= -60:
                proximity = "Hider has been found!"
                device.play(.success)
            case let x where x >= -100:
                proximity = "A hider is nearby."
                device.play(.click)
            default:
                proximity = "No one is nearby."
                device.play(.directionUp)
            }
        }
        
        DispatchQueue.main.async {
            self.proximityText = proximity!
        }
    }
    
    func playSound(fileName: String, fileType: String) {
        if let path = Bundle.main.path(forResource: fileName, ofType: fileType) {
            let url = URL(fileURLWithPath: path)
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.play()
            } catch {
                print("Error: Could not find and play the sound file.")
            }
        }
    }
}
