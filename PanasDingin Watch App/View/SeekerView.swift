//
//  SeekerView.swift
//  PanasDingin Watch App
//
//  Created by Brendan Alexander Soendjojo on 26/05/24.
//

import SwiftUI

struct SeekerView: View {
    @StateObject private var seekerCentralManager = CentralManager()
    @StateObject private var seekerPeripheralManager = PeripheralManager()
    private func gradientColor(for rssi: Int) -> [Color] {
        // Map the RSSI value to a gradient color set
        let rssiNormalized = max(min(rssi, -40), -100)
        let ratio = CGFloat(rssiNormalized + 100) / 60.0
        
        let startColor = Color("Dark Blue").opacity(Double(1 - ratio))
        let endColor = Color("Dark Red").opacity(Double(ratio))
        
        return [startColor, endColor]
    }
    
    var body: some View {
        VStack {
            
            Text("Seeker")
                .font(.headline)
            
            Spacer()
            
            Text(seekerCentralManager.proximityText.rawValue)
                .font(.caption)
                .padding()
            
            Spacer()
            
            Button(action: {
                if seekerCentralManager.searching {
                    self.seekerCentralManager.stopScanning()
                    self.seekerPeripheralManager.stopAdvertising()
                    self.seekerCentralManager.proximityText = .start
                } else {
                    self.seekerCentralManager.startScanning(role: .seeker)
                    self.seekerPeripheralManager.startAdvertising(role: .seeker)
                    self.seekerCentralManager.proximityText = .hiderFar
                }
            }) {
                Text(seekerCentralManager.searching ? "Stop" : "Start")
                    .foregroundStyle(seekerCentralManager.searching ? .red : .white)
            }.padding()
            
        }.background(
            LinearGradient(gradient: Gradient(colors: gradientColor(for: seekerCentralManager.rssiValue)), startPoint: .topTrailing, endPoint: .bottomLeading)
                            .edgesIgnoringSafeArea(.all)
        ).onDisappear {
            if seekerCentralManager.searching {
                self.seekerCentralManager.stopScanning()
                self.seekerPeripheralManager.stopAdvertising()
            }
        }
    }
}

#Preview {
    SeekerView()
}
