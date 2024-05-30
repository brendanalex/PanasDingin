//
//  HomeView.swift
//  PanasDingin Mac App
//
//  Created by Brendan Alexander Soendjojo on 26/05/24.
//

import SwiftUI

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

