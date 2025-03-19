//
//  CategoryScreen.swift
//  ZellFarms
//
//  Created by mac on 19/03/2025.
//

import SwiftUI

struct CategoryScreen: View {
    @State private var category = CategoryRepo()
    @State private var categories: [Categories] = []
    
    let layout = [
        GridItem(.flexible(), spacing: 5),
        GridItem(.flexible(), spacing: 5)
    ]
    
    var body: some View {
        NavigationStack {
            VStack {
                if category.isLoading {
                    ProgressView()
                } else {
                    ScrollView(showsIndicators: false) {
                        LazyVGrid(columns: layout, spacing: 6) {
                            ForEach(categories, id: \.id) { categorize in
                                CategoryCard(category: categorize)
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Category")
            .navigationBarTitleDisplayMode(.inline)
            .task {
                do {
                    let loadedCategories = try await category.getCategories()
                    categories = loadedCategories
                } catch {
                }
            }
            .snackbar(
                isShowing: $category.showErrorSnackbar,
                message: category.error ?? ""
            )
            .snackbar(
                isShowing: $category.showSuccessSnackbar,
                message: category.successMessage ?? "",
                isSuccess: true
            )
        }
    }
}

#Preview {
    CategoryScreen()
}
