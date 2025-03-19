//
//  HomeScreen.swift
//  ZellFarms
//
//  Created by mac on 19/03/2025.
//

import SwiftUI

struct HomeScreen: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 15) {
                    HStack {
                        Image("zelwhite")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                        
                        Spacer()
                        
                        Image(systemName: "cart.fill")
                            .foregroundStyle(.accent)
                            .font(.title2)
                    }
                    
                    Text("Welcome back")
                        .font(.system(size: 20))
                        .foregroundStyle(.accent)
                    
                    Text("Somto Obi")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(.accent)
                    
                    Text("What would you like to order today?")
                        .font(.system(size: 18))
                }
            }
            .padding()
        }
    }
}

#Preview {
    HomeScreen()
}
