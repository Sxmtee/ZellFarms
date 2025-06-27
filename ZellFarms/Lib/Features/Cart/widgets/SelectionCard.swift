//
//  SelectionCard.swift
//  ZellFarms
//
//  Created by mac on 27/06/2025.
//

import SwiftUI

struct SelectionCard: View {
    let emoji: String
    let name: String
    let description: String
    let isSelected: Bool
    
    var body: some View {
        HStack(spacing: 10) {
            Text(emoji)
                .font(.system(size: 24))
            
            VStack(alignment: .leading, spacing: 5) {
                Text(name)
                    .font(.system(size: 16, weight: .bold))
                Text(description)
                    .font(.system(size: 14))
                    .foregroundColor(isSelected ? .white.opacity(0.9) : .gray)
            }
            Spacer()
        }
        .padding(10)
        .background(
            isSelected ? Color(hex: 0xFF6200EE) : Color(.systemBackground)
        )
        .cornerRadius(10)
        .foregroundColor(isSelected ? .white : .primary)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(isSelected ? Color.clear : Color.gray.opacity(0.2), lineWidth: 1)
        )
    }
}
