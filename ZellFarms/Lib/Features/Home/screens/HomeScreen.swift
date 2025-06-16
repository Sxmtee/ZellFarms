//
//  HomeScreen.swift
//  ZellFarms
//
//  Created by mac on 19/03/2025.
//

import SwiftUI

struct HomeScreen: View {
    @State private var name = ZelPreferences.username
    
    var body: some View {
        ScrollView(showsIndicators: false) {
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
                
                if name != "" {
                    Text(name)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(.accent)
                }
                
                Text("What would you like to order today?")
                    .font(.system(size: 18))
                
                HomeCategory()
                
                HomeTodayChoice()
                
                HomeLimitedDiscount()
                
                HomeCheapest()
                
                HomeTodaySpecial()
            }
        }
        .padding()
        .padding(.bottom, 60)
    }
}
