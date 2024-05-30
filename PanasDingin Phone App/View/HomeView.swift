//
//  HomeView.swift
//  PanasDingin Phone App
//
//  Created by Brendan Alexander Soendjojo on 21/05/24.
//

import CoreBluetooth
import SwiftUI

struct HomeView: View {
    var body: some View {
            NavigationView {
                ZStack {
                    LinearGradient(gradient: Gradient(colors: [Color("Dark Blue").opacity(0.7), Color("Dark Red").opacity(0.6)]), startPoint: .topTrailing, endPoint: .bottomLeading)
                        .edgesIgnoringSafeArea(.all)
                    
                    VStack {
                        Text("Choose Your Role")
                            .font(.largeTitle).bold()
                            .padding()
                        
                        Spacer()
                        
                        HStack {
                            Image("hider")
                                .resizable()
                                .aspectRatio(contentMode:.fit)
                                .frame(height: 30)
                                .padding(.leading,10)
                                .foregroundColor(.white)
                            NavigationLink(destination: HiderView()) {
                                Text("Hider")
                                    .font(.callout)
                            }
                            .padding(.horizontal)
                        }.padding(.bottom,50)
                        
                        HStack {
                            Image("seeker")
                                .resizable()
                                .aspectRatio(contentMode:.fit)
                                .frame(height: 42)
                                .padding(.leading,15)
                            NavigationLink(destination: SeekerView()) {
                                Text("Seeker")
                                    .font(.callout)
                            }
                            .padding(.horizontal)
                        }
                        
                        Spacer()
                    }
                }
            }
        }
}

#Preview {
    HomeView()
}
