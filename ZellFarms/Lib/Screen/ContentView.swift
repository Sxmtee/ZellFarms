//
//  ContentView.swift
//  ZellFarms
//
//  Created by mac on 17/03/2025.
//

import SwiftUI

enum Tab: String, CaseIterable {
    case Home = "Home"
    case Category = "Category"
    case Search = "Search"
    case Order = "Order"
    case Account = "Account"
    
    var iconName: String {
        switch self {
        case .Home:
            return "house.fill"
        case .Category:
            return "rectangle.grid.2x2.fill"
        case .Search:
            return "magnifyingglass"
        case .Order:
            return "text.document.fill"
        case .Account:
            return "person.fill"
        }
    }
}

struct ContentView: View {
    @State private var currentTab: Tab = .Home
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $currentTab) {
                HomeScreen()
                    .tag(Tab.Home)
                
                CategoryScreen()
                    .tag(Tab.Category)
                
                Text("Notifications View")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.white)
                    .tag(Tab.Search)
                
                Text("Cart View")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.white)
                    .tag(Tab.Order)
                
                Text("Profile View")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.white)
                    .tag(Tab.Account)
            }
            
            // Custom Tab Bar
            HStack(spacing: 0) {
                ForEach(Tab.allCases, id: \.self) { tab in
                    TabButton(
                        tab: tab,
                        currentTab: $currentTab
                    )
                }
            }
            .padding(.vertical, 25)
            .padding(.horizontal, 10)
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .shadow(
                color: Color.black.opacity(0.15),
                radius: 3,
                x: 0,
                y: -2
            )
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

#Preview {
    ContentView()
}
