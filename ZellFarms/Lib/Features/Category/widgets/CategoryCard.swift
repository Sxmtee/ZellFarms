//
//  CategoryCard.swift
//  ZellFarms
//
//  Created by mac on 19/03/2025.
//

import SwiftUI

struct CategoryCard: View {
    let category: Categories
    
    var body: some View {
        NavigationLink(
            destination: Text(category.name)
        ) {
            VStack {
                Text(category.name)
                    .font(.system(size: 16, weight: .bold))
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                Text("\(category.products.count) Product(s)")
                    .font(.system(size: 14, weight: .medium))
                    .lineLimit(1)
                
                Spacer()
                
                Text(categoryEmoji(for: category.name))
                    .font(.system(size: 25))
                    .frame(width: 30, height: 40)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color(.systemBackground))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray.opacity(0.5), lineWidth: 0.5)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func categoryEmoji(for name: String) -> String {
        switch name {
        case "Fruits": return "🍇"
        case "Seafood": return "🦞"
        case "Snacks": return "🥟"
        case "Bakery Items": return "🍞"
        case "Beverages": return "☕️"
        case "Dairy Products": return "🥛"
        case "Frozen Foods": return "🧆"
        case "Grains & Pulses": return "🌾"
        case "Herbs & Spices": return "🌿"
        case "Honey & Syrups": return "🍯"
        case "Meat & Poultry": return "🍗"
        case "Nuts & Seeds": return "🌰"
        case "Organic Products": return "🧆"
        case "Vegetables": return "🥒"
        default: return "🥚"
        }
    }
}
