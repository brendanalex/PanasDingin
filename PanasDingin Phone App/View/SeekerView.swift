//
//  SeekerView.swift
//  PanasDingin Phone App
//
//  Created by Brendan Alexander Soendjojo on 26/05/24.
//

import SwiftUI

struct SeekerView: View {
    @StateObject private var seekerCentralManager = CentralManager()
    @StateObject private var seekerPeripheralManager = PeripheralManager()
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color("Dark Blue").opacity(0.7), Color("Dark Red").opacity(0.6)]), startPoint: .topTrailing, endPoint: .bottomLeading)
                .edgesIgnoringSafeArea(.all)
            VStack {
                Text("Seeker")
                    .font(.headline)
                Spacer()
                Text(seekerCentralManager.proximityText)
                    .font(.caption)
                    .padding()
                Spacer()
                Button(action: {
                    if seekerCentralManager.searching {
                        seekerCentralManager.stopScanning()
                        seekerPeripheralManager.stopAdvertising()
                        seekerCentralManager.proximityText = "Press start if ready."
                    } else {
                        seekerCentralManager.startScanning(role: .seeker)
                        seekerPeripheralManager.startAdvertising(role: .seeker)
                        seekerCentralManager.proximityText = "No one is nearby."
                    }
                }) {
                    Text(seekerCentralManager.searching ? "Stop" : "Start")
                        .foregroundStyle(seekerCentralManager.searching ? .red : .white)
                }.padding()
            }.onDisappear {
                if seekerCentralManager.searching {
                    seekerCentralManager.stopScanning()
                    seekerPeripheralManager.stopAdvertising()
                }
        }
        }
    }
}

#Preview {
    SeekerView()
}
