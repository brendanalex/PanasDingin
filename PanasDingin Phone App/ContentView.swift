//
//  ContentView.swift
//  PanasDingin Phone App
//
//  Created by Brendan Alexander Soendjojo on 21/05/24.
//

import SwiftUI

//struct ContentView: View {
//
//    @StateObject private var seekerManager = SeekerCentralManager()
//
//    var body: some View {
//        VStack {
//            List(seekerManager.allPeri, id: \.identifier) { peri in
//                Text("\(peri.identifier.uuidString)")
//            }
//
//        }
//        .padding()
//    }
//}

struct ContentView: View {
    
    @StateObject private var hiderManager = HiderPeripheralManager()
    
    var body: some View {
        VStack {
            Button(action: {
                hiderManager.startAdvertising()
            }) {
                Text("Start Playing")
            }.disabled(hiderManager.didAdvertised)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
