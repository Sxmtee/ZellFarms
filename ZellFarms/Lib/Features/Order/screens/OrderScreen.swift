//
//  OrderScreen.swift
//  ZellFarms
//
//  Created by mac on 25/06/2025.
//

import SwiftUI

struct OrderScreen: View {
    @State private var cartRepo = CartRepo()
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .task {
//                await cartRepo.getDeliveryChannel()
            }
    }
}

#Preview {
    OrderScreen()
}
