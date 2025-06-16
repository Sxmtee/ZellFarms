//
//  HomeTodayChoice.swift
//  ZellFarms
//
//  Created by mac on 17/04/2025.
//

import SwiftUI

struct HomeTodayChoice: View {
    @State private var product = CategoryRepo()
    @State private var todaysChoices: [ProductCheapest] = []
    @State private var isDataLoaded = false
    
    @Environment(Router.self) private var router
    
    var body: some View {
        VStack(alignment: .leading) {
            if product.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: 150)
            } else if isDataLoaded && !todaysChoices.isEmpty {
                SectionTitleAll(
                    title: "Today's Choice 👍🏾",
                    titleAll: "See all >",
                    onTap: {
                        router.push(
                            .homeTodayChoiceSeeAll(todayChoicesList: todaysChoices)
                        )
                    }
                )
                
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 15) {
                        ForEach(
                            todaysChoices.prefix(todaysChoices.count > 4 ? 4 : todaysChoices.count),
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
                let loadedTodaysChoice = try await product.getProducts()
                todaysChoices = loadedTodaysChoice.todayChoices
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
    HomeTodayChoice()
        .environment(Router())
}
