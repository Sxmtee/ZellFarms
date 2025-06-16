//
//  AuthScreen.swift
//  ZellFarms
//
//  Created by mac on 23/05/2025.
//

import SwiftUI

struct AuthScreen: View {
    @State private var selectedIndex = 0
    let toggleItems = ["Login", "Register"]
    
    var body: some View {
        VStack(alignment: .leading) {
            Image("zelwhite")
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
                .padding(.bottom, 10)
            
            if selectedIndex == 0 {
                Text("Login to your\nAccount")
                    .font(.system(size: 20, weight: .medium))
            } else {
                Text("Create your\nAccount")
                    .font(.system(size: 20, weight: .medium))
            }
            
            Picker("Select Option", selection: $selectedIndex) {
                ForEach(0..<toggleItems.count, id: \.self) { index in
                    Text(toggleItems[index])
                        .tag(index)
                }
            }
            .pickerStyle(.segmented)
            .padding(.bottom, 20)
            .padding(.top, 20)
            
            if selectedIndex == 0 {
                Login()
            } else {
                Register()
            }
        }
        .padding(15)
    }
}
