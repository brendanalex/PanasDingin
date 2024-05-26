//
//  ContentView.swift
//  PanasDingin Watch App
//
//  Created by Brendan Alexander Soendjojo on 15/05/24.
//

import CoreBluetooth
import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                
                Text("Panas Dingin")
                    .font(.title2)
                    .padding()
                
                Spacer()
                
                HStack {
                    Image(systemName: "figure.arms.open")
                        .resizable()
                        .aspectRatio(contentMode:.fit)
                        .frame(height: 40)
                        .padding(.leading,10)
                    NavigationLink(destination: HiderView()) {
                        Text("Hide ")
                            .font(.headline)
                    }
                    .padding(.horizontal)
                }.padding(.bottom,5)
                
                HStack {
                    Image(systemName: "figure.walk")
                        .resizable()
                        .aspectRatio(contentMode:.fit)
                        .frame(height: 40)
                        .padding(.leading,10)
                    NavigationLink(destination: SeekerView()) {
                        Text("Seek ")
                            .font(.headline)
                    }
                    .padding(.horizontal)
                }
                
                Spacer()
                
            }.background(
                LinearGradient(gradient: Gradient(colors: [Color("Dark Blue").opacity(0.7), Color("Dark Red").opacity(0.6)]), startPoint: .topTrailing, endPoint: .bottomLeading)
                    .edgesIgnoringSafeArea(.all)
            )
        }
    }
}

#Preview {
    ContentView()
}
