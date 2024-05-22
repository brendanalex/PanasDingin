//
//  ContentView.swift
//  PanasDingin Watch App
//
//  Created by Brendan Alexander Soendjojo on 15/05/24.
//

import CoreBluetooth
import SwiftUI

struct SeekerContentView: View {
    @StateObject private var seekerManager = SeekerCentralManager()

    var body: some View {
        VStack {
            Text("\(seekerManager.searching)")
                .font(.headline)
            Spacer()
            List(seekerManager.allPeri, id: \.identifier) { peri in
                Text("\(peri.identifier.uuidString)")
            }
            Spacer()
            Text(seekerManager.proximityText)
                .font(.caption)
                .padding()
            Spacer()
            Button(action: {
                seekerManager.startScanning()
            }) {
                Text("Start Seeking")
            }.disabled(seekerManager.searching)
        }
    }
}
