//
//  HomeTodaySpecial.swift
//  ZellFarms
//
//  Created by mac on 18/04/2025.
//

import SwiftUI

struct HomeTodaySpecial: View {
    @State private var product = CategoryRepo()
    @State private var todaySpecial: [ProductCheapest] = []
    @State private var isDataLoaded = false
    
    @Environment(Router.self) private var router
    
    var body: some View {
        VStack(alignment: .leading) {
            if product.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: 150)
            } else if isDataLoaded && !todaySpecial.isEmpty {
                SectionTitleAll(
                    title: "Today's Special 🍱",
                    titleAll: "See all >",
                    onTap: {
                        router.push(
                            .homeTodaySpecialSeeAll(todaySpecialList: todaySpecial)
                        )
                    }
                )
                
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 15) {
                        ForEach(
                            todaySpecial.prefix(todaySpecial.count > 4 ? 4 : todaySpecial.count),
                            id: \.id
                        ) { category in
                            HomeProductCard(
                                picture: category.images.first?.url ?? "",
                                productName: category.name,
                                unitPrice: "Unit Price/ \(category.productUnits[0].unit.symbol)",
                                onTap: {
                                    router.push(.productSalePage(cheapest: category))
                                }
                            )
                        }
                    }
                }
                .frame(height: 200)
            } else if isDataLoaded {
                EmptyView()
            }
        }
        .task {
            do {
                let loaded = try await product.getProducts()
                todaySpecial = loaded.todaySpecials
                isDataLoaded = true
            } catch {
                print("Failed to load products: \(error.localizedDescription)")
                isDataLoaded = true
            }
        }
        .environment(router)
    }
}
