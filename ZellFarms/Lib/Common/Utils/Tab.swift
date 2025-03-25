//
//  Tab.swift
//  ZellFarms
//
//  Created by mac on 24/03/2025.
//


// Tab.swift
import SwiftUI

enum Tab: String, CaseIterable {
    case Home = "Home"
    case Category = "Category"
    case Search = "Search"
    case Order = "Order"
    case Account = "Account"
    
    var iconName: String {
        switch self {
        case .Home: return "house.fill"
        case .Category: return "rectangle.grid.2x2.fill"
        case .Search: return "magnifyingglass"
        case .Order: return "text.document.fill"
        case .Account: return "person.fill"
        }
    }
}