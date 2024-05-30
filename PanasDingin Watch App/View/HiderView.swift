//
//  HiderView.swift
//  PanasDingin Watch App
//
//  Created by Brendan Alexander Soendjojo on 26/05/24.
//

import SwiftUI

struct HiderView: View {
    @StateObject private var hiderCentralManager = CentralManager()
    @StateObject private var hiderPeripheralManager = PeripheralManager()
    private func gradientColor(for rssi: Int) -> [Color] {
        // Map the RSSI value to a gradient color set
        let rssiNormalized = max(min(rssi, -30), -100)
        let ratio = CGFloat(rssiNormalized + 100) / 70.0
        
        let startColor = Color("Dark Blue").opacity(Double(1 - ratio))
        let endColor = Color("Dark Red").opacity(Double(ratio))
        
        return [startColor, endColor]
    }
    
    var body: some View {
        VStack {
            Text("Hider")
                .font(.headline)
            
            Spacer()
            
            Text(hiderCentralManager.proximityText.rawValue)
                .font(.caption)
                .padding()
            
            Spacer()
            
            Button(action: {
                self.hiderCentralManager.peripheralManager = hiderPeripheralManager
                self.hiderCentralManager.startScanning(role: .hider)
                self.hiderPeripheralManager.startAdvertising(role: .hider)
                self.hiderCentralManager.proximityText = .seekerFar
            }) {
                Text("Start")
            }.disabled(hiderCentralManager.searching)
            .padding()
            
        }.background(
            LinearGradient(gradient: Gradient(colors: gradientColor(for: hiderCentralManager.rssiValue)), startPoint: .topTrailing, endPoint: .bottomLeading)
                            .edgesIgnoringSafeArea(.all)
        ).onDisappear {
            if hiderCentralManager.searching {
                self.hiderCentralManager.stopScanning()
                self.hiderPeripheralManager.stopAdvertising()
            }
        }
    }
}

#Preview {
    HiderView()
}

