//
//  DetailAd.swift
//  ZellFarms
//
//  Created by mac on 25/03/2025.
//

import SwiftUI

struct DetailAd: View {
    var body: some View {
        HStack(spacing: 0) {
            // Origin Section
            VStack {
                Text("Origin")
                    .foregroundColor(.gray)
                Text("Farm")
                    .font(.system(size: 18))
                    .fontWeight(.bold)
            }
            .frame(maxWidth: .infinity)
            
            // First Divider
            Divider()
                .frame(width: 1)
                .background(Color(UIColor.systemBackground))
            
            // Condition Section
            VStack {
                Text("Condition")
                    .foregroundColor(.gray)
                Text("Fresh")
                    .font(.system(size: 18))
                    .fontWeight(.bold)
            }
            .frame(maxWidth: .infinity)
            
            // Second Divider
            Divider()
                .frame(width: 1)
                .background(Color(UIColor.systemBackground))
            
            // Fat Content Section
            VStack {
                Text("Fat content")
                    .foregroundColor(.gray)
                Text("Non Fatty")
                    .font(.system(size: 18))
                    .fontWeight(.bold)
            }
            .frame(maxWidth: .infinity)
        }
        .frame(height: UIScreen.main.bounds.height * 0.1)
        .padding(10)
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color(UIColor(.gray.opacity(0.5))), lineWidth: 1)
        )
    }
}


#Preview {
    DetailAd()
}
