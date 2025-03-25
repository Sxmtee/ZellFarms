//
//  BottomNavigationBar.swift
//  ZellFarms
//
//  Created by mac on 25/03/2025.
//

import SwiftUI

struct BottomNavigationBar: View {
    @Binding var selectedProductUnit: ProductUnit
    @Binding var totalQuantity: Int
    let product: Product
    
    // Methods to increment and decrement quantity
    private func decrement() {
        if totalQuantity > 1 {
            totalQuantity -= 1
        }
    }
    
    private func increment() {
        totalQuantity += 1
    }
    
    // Method to calculate total price
    private func calculateTotalPrice() -> Double {
        return Double(selectedProductUnit.pricePerUnit) * Double(totalQuantity)
    }
    
    var body: some View {
        HStack {
            // Quantity Control Container
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
            
            // Add to Cart Button
            Button(action: {
                // TODO: Implement cart logic
                // Similar to your Flutter implementation
                // Consider handling local cart or network cart based on authentication status
            }) {
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
