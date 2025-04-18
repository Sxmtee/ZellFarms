//
//  CategoryProduct.swift
//  ZellFarms
//
//  Created by mac on 24/03/2025.
//

import SwiftUI

struct CategoryProduct: View {
    let products: [Product]
    
    @Environment(Router.self) private var router
    
    var body: some View {
        if products.isEmpty {
            ContentUnavailableView("No Products Available", systemImage: "cart")
        } else {
            List {
                ForEach(products, id: \.id) { product in
                    Button {
                        router.push(.categoryProductPage(product: product))
                    } label: {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(product.name)
                                    .font(.system(size: 16, weight: .bold))
                                    .padding(.bottom, 5)
                                
                                Text(
                                    formatPrice(
                                        String(product.productUnits[0].pricePerUnit)
                                    )
                                )
                                .font(.system(size: 14))
                            }
                            
                            Spacer()
                            
                            Text("🥘")
                                .font(.system(size: 25))
                                .frame(width: 30, height: 40)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }
}
