//
//  HomeLimitedDiscount.swift
//  ZellFarms
//
//  Created by mac on 18/04/2025.
//

import SwiftUI

struct HomeLimitedDiscount: View {
    @State private var product = CategoryRepo()
    @State private var limitedDiscount: [ProductCheapest] = []
    @State private var isDataLoaded = false
    
    @Environment(Router.self) private var router
    
    var body: some View {
        VStack(alignment: .leading) {
            if product.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: 150)
            } else if isDataLoaded && !limitedDiscount.isEmpty {
                SectionTitleAll(
                    title: "Limited Discount 🎉",
                    titleAll: "See all >",
                    onTap: {
                        router.push(
                            .homeLimitedDiscountSeeAll(limitedDiscountList: limitedDiscount)
                        )
                    }
                )
                
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 15) {
                        ForEach(
                            limitedDiscount.prefix(limitedDiscount.count > 4 ? 4 : limitedDiscount.count),
                            id: \.id
                        ) { category in
                            HomeProductCard(
                                picture: category.images.first?.url ?? "",
                                productName: category.name,
                                unitPrice: "Unit Price/ \(category.productUnits[0].unit.symbol.rawValue)",
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
                limitedDiscount = loaded.limitedDiscount
                isDataLoaded = true
            } catch {
                print("Failed to load products: \(error.localizedDescription)")
                isDataLoaded = true
            }
        }
        .environment(router)
    }
}

#Preview {
    HomeLimitedDiscount()
        .environment(Router())
}
