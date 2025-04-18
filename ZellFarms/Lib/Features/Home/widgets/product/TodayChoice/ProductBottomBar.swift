//
//  ProductBottomBar.swift
//  ZellFarms
//
//  Created by mac on 18/04/2025.
//

import SwiftUI

struct ProductBottomBar: View {
    @Binding var selectedProductUnit: ProductProductUnit
    @Binding var totalQuantity: Int
    let cheapest: ProductCheapest
    
    private func decrement() {
        if totalQuantity > 1 {
            totalQuantity -= 1
        }
    }

    private func increment() {
        if totalQuantity < selectedProductUnit.availableQuantity {
            totalQuantity += 1
        }
    }

    private func calculateTotalPrice() -> Double {
        return Double(selectedProductUnit.pricePerUnit) * Double(totalQuantity)
    }
    
    var body: some View {
        HStack {
            HStack {
                Button(action: decrement) {
                    Image(systemName: "minus")
                }

                Text("\(totalQuantity)")
                    .padding(.horizontal)

                Button(action: increment) {
                    Image(systemName: "plus")
                }
            }
            .padding()
            .background(Color.secondary.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 15))
            
            Button {
                //TODO: Add to cart
            } label: {
                HStack {
                    Text("\(formatPrice(String(calculateTotalPrice()))) | Add to Cart")
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.accentColor)
                .clipShape(RoundedRectangle(cornerRadius: 15))
            }
        }
        .padding(.vertical, 20)
        .padding(.horizontal)
        .background(Color(UIColor.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .shadow(color: .black.opacity(0.1), radius: 5)
    }
}
