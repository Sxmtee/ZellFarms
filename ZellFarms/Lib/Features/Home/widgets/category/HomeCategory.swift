//
//  HomeCategory.swift
//  ZellFarms
//
//  Created by mac on 10/04/2025.
//

import SwiftUI

struct HomeCategory: View {
    @State private var category = CategoryRepo()
    
    @Environment(Router.self) private var router
    
    private let desiredCategories = ["Eggs", "Fruits", "Seafood", "Snacks"]
    
    private var filteredCategories: [Categories] {
        return category.categories.filter {
            desiredCategories.contains($0.name)
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            SectionTitleAll(
                title: "Categories",
                titleAll: "See all >",
                onTap: {
                    router.push(.categorySeeAll(categories: category.categories))
                }
            )
            
            if category.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: 150)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 15) {
                        ForEach(filteredCategories, id: \.id) { category in
                            HomeCategoryItem(category: category)
                        }
                    }
                }
                .frame(height: 150)
            }
            
        }
        .task {
            await category.getCategories()
        }
        .environment(router)
    }
}

#Preview {
    HomeCategory()
        .environment(Router())
}
