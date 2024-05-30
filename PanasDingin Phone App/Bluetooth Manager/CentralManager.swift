//
//  CentralManager.swift
//  PanasDingin Phone App
//
//  Created by Brendan Alexander Soendjojo on 26/05/24.
//

import CoreBluetooth
import AVFoundation

class CentralManager: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    var centralManager: CBCentralManager?
    var peripheralManager: PeripheralManager?
    var currentRole: Role?
    private var discoveredPeripherals: [UUID: CBPeripheral] = [:]
    private var lastRSSICheckTime: Date?
    var audioPlayer: AVAudioPlayer?
    @Published var proximityText: ProximityType = .start
    @Published var rssiValue: Int = -100
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
            uuid = RoleUUID.seeker
            currentRole = .hider
        case .seeker:
            uuid = RoleUUID.hider
            currentRole = .seeker
        }
        
        centralManager?.scanForPeripherals(withServices: [uuid!], options: [CBCentralManagerScanOptionAllowDuplicatesKey: true])
    }
    
    func stopScanning() {
        searching = false
        cancelAllConnections()
        discoveredPeripherals.removeAll()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.centralManager?.stopScan()
        }
    }
    
    func cancelAllConnections() {
        for (_, peripheral) in discoveredPeripherals {
            centralManager?.cancelPeripheralConnection(peripheral)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        peripheral.delegate = self
        discoveredPeripherals[peripheral.identifier] = peripheral
        centralManager?.connect(peripheral, options: nil)
        if shouldUpdateProximity(){
            handleProximity(RSSI: RSSI)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        DispatchQueue.main.async {
            if self.currentRole == .seeker {
                self.proximityText = .hiderFar
            }
        }
        discoveredPeripherals.removeValue(forKey: peripheral.identifier)
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
        self.rssiValue = RSSI.intValue
        
        switch currentRole {
        case .hider:
            if rssiValue >= -50 {
                self.proximityText = .seekerFound
                playSound(fileName: "Lose", fileType: "mp3")
                stopScanning()
                peripheralManager?.stopAdvertising()
            } else {
                self.proximityText = .seekerNear
            }
        case .seeker:
            if rssiValue >= -50 {
                self.proximityText = .hiderFound
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    self.rssiValue = -100
                    self.proximityText = .hiderFar
                }
            } else {
                self.proximityText = .hiderNear
            }
        case .none:
            print("Role is unassigned.")
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
