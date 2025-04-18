//
//  HomeCategoryItem.swift
//  ZellFarms
//
//  Created by mac on 10/04/2025.
//

import SwiftUI

struct HomeCategoryItem: View {
    let category: Categories
    
    @Environment(Router.self) private var router
    
    var body: some View {
        VStack {
            Button {
                router.push(.categoryProduct(category: category))
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.accentColor, lineWidth: 1)
                        .frame(width: 80, height: 80)
                    
                    Text(categoryEmoji)
                        .font(.system(size: 40))
                }
            }
            
            Text(category.name)
                .font(.system(size: 14))
                .multilineTextAlignment(.center)
        }
    }
    
    private var categoryEmoji: String {
        switch category.name {
        case "Fruits": return "🍇"
        case "Seafood": return "🦞"
        case "Snacks": return "🥟"
        case "Eggs": return "🥚"
        default: return ""
        }
    }
}
