//
//  HomeCategorySeeAll.swift
//  ZellFarms
//
//  Created by mac on 17/04/2025.
//

import SwiftUI

struct HomeCategorySeeAll: View {
    let categories: [Categories]
    
    let layout = [
        GridItem(.flexible(), spacing: 5),
        GridItem(.flexible(), spacing: 5)
    ]
    
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: layout, spacing: 6) {
                    ForEach(categories, id: \.id) { categorize in
                        CategoryCard(category: categorize)
                    }
                }
                .padding()
            }
        }
        .navigationTitle("All Categories")
    }
}
