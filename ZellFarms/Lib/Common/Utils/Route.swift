//
//  Route.swift
//  ZellFarms
//
//  Created by mac on 24/03/2025.
//


// Router.swift
import SwiftUI

enum Route: Hashable {
    case categoryProduct(category: Categories)
    case categoryProductPage(product: Product)
}

@Observable
class Router {
    var path = NavigationPath()
    
    func push(_ route: Route) {
        path.append(route)
    }
    
    func replace(_ route: Route) {
        if !path.isEmpty {
            path.removeLast()
        }
        path.append(route)
    }
    
    func reset(to route: Route) {
        path = NavigationPath()
        path.append(route)
    }
    
    func pop() {
        if !path.isEmpty {
            path.removeLast()
        }
    }
}
