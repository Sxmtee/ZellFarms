//
//  HomeTodayChoiceSeeAll.swift
//  ZellFarms
//
//  Created by mac on 18/04/2025.
//

import SwiftUI

struct HomeTodayChoiceSeeAll: View {
    let todayChoicesList: [ProductCheapest]
    
    @Environment(Router.self) private var router
    
    let layout = [
        GridItem(.flexible(), spacing: 5),
        GridItem(.flexible(), spacing: 5)
    ]
    
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: layout, spacing: 15) {
                    ForEach(todayChoicesList, id: \.id) { choice in
                        HomeProductCard(
                            picture: choice.images.first?.url ?? "",
                            productName: choice.name,
                            unitPrice: "Unit Price/ \(choice.productUnits[0].unit.symbol)",
                            onTap: {
                                router.push(.productSalePage(cheapest: choice))
                            }
                        )
                    }
                }
                .padding()
            }
        }
        .navigationTitle("All Today's Choices")
    }
}
