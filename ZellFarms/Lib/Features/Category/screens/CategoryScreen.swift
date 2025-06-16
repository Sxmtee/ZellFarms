//
//  CategoryScreen.swift
//  ZellFarms
//
//  Created by mac on 19/03/2025.
//

import SwiftUI

struct CategoryScreen: View {
    @State private var category = CategoryRepo()
    
    let layout = [
        GridItem(.flexible(), spacing: 5),
        GridItem(.flexible(), spacing: 5)
    ]
    
    var body: some View {
        VStack {
            if category.isLoading {
                ProgressView()
            } else {
                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: layout, spacing: 6) {
                        ForEach(category.categories, id: \.id) { categorize in
                            CategoryCard(category: categorize)
                        }
                    }
                    .padding()
                }
            }
            
            Spacer()
        }
        .padding(.bottom, 60)
        .task {
            await category.getCategories()
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
