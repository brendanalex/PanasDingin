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
    
    var body: some View {
        VStack {
            Text("Hider")
                .font(.headline)
            
            Spacer()
            
            Text(hiderCentralManager.proximityText)
                .font(.caption)
                .padding()
            
            Spacer()
            
            Button(action: {
                hiderCentralManager.peripheralManager = hiderPeripheralManager 
                hiderCentralManager.startScanning(role: .hider)
                hiderPeripheralManager.startAdvertising(role: .hider)
                hiderCentralManager.proximityText = "Seeker is far away."
            }) {
                Text("Start")
            }.disabled(hiderCentralManager.searching)
            .padding()
            
        }.background(
            LinearGradient(gradient: Gradient(colors: [Color("Dark Blue").opacity(0.7), Color("Dark Red").opacity(0.6)]), startPoint: .topTrailing, endPoint: .bottomLeading)
                .edgesIgnoringSafeArea(.all)
        ).onDisappear {
            if hiderCentralManager.searching {
                hiderCentralManager.stopScanning()
                hiderPeripheralManager.stopAdvertising()
            }
        }
    }
}

#Preview {
    HiderView()
}

