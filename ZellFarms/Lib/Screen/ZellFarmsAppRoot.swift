//
//  ZellFarmsAppRoot.swift
//  ZellFarms
//
//  Created by mac on 24/03/2025.
//

import SwiftUI

struct ZellFarmsAppRoot: View {
    @State private var router = Router()
    @State private var currentTab: Tab = .Home
    
    var body: some View {
        NavigationStack(path: $router.path) {
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
                    CategoryProduct(
                        products: category.products,
                        title: category.name
                    )
                case .categoryProductPage(let product):
                    CategoryProductPage(product: product)
                }
            }
        }
        .environment(router)
    }
}

#Preview {
    ZellFarmsAppRoot()
}
