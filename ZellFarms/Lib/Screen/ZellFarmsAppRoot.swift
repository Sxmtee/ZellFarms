//
//  ZellFarmsAppRoot.swift
//  ZellFarms
//
//  Created by mac on 24/03/2025.
//

import SwiftUI

struct ZellFarmsAppRoot: View {
    @Environment(Router.self) private var router
    @State private var currentTab: Tab = .Home
    
    var body: some View {
        NavigationStack(path: Binding(
            get: { router.path },
            set: { router.path = $0 }
        )) {
            ZStack(alignment: .bottom) {
                switch currentTab {
                case .Home:
                    HomeScreen()
                    
                case .Category:
                    CategoryScreen()
                    
                case .Search:
                    Text("Notifications View")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.white)
                    
                case .Order:
                    Text("Cart View")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.white)
                    
                case .Account:
                    Text("Profile View")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.white)
                }
                
                HStack(spacing: 0) {
                    ForEach(Tab.allCases, id: \.self) { tab in
                        TabButton(tab: tab, currentTab: $currentTab)
                    }
                }
                .padding(.vertical, 25)
                .padding(.horizontal, 10)
                .background(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .shadow(
                    color: Color.black.opacity(0.15),
                    radius: 3, x: 0, y: -2
                )
            }
            .ignoresSafeArea(edges: .bottom)
            .navigationTitle(currentTab.rawValue)
            .toolbar(currentTab == .Home ? .hidden : .visible, for: .navigationBar)
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .categoryProduct(let category):
                    CategoryProduct(products: category.products)
                        .environment(router)
                case .categoryProductPage(let product):
                    CategoryProductPage(product: product)
                        .environment(router)
                case .categorySeeAll(let categories):
                    HomeCategorySeeAll(categories: categories)
                        .environment(router)
                case .productSalePage(let cheapest):
                    ProductSalePage(cheapest: cheapest)
                        .environment(router)
                case .homeTodayChoiceSeeAll(let todayChoicesList):
                    HomeTodayChoiceSeeAll(todayChoicesList: todayChoicesList)
                        .environment(router)
                case .homeLimitedDiscountSeeAll(let limitedDiscountList):
                    HomeLimitedDiscountSeeAll(limitedDiscountList: limitedDiscountList)
                        .environment(router)
                case .homeCheapestSeeAll(let cheapestList):
                    HomeCheapestSeeAll(cheapestList: cheapestList)
                        .environment(router)
                case .homeTodaySpecialSeeAll(let todaySpecialList):
                    HomeTodaySpecialSeeAll(todaySpecialList: todaySpecialList)
                        .environment(router)
                }
            }
        }
        .environment(router)
    }
}

#Preview {
    ZellFarmsAppRoot()
        .environment(Router())
}
