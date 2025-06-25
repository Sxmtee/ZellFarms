//
//  CartSummaryFooter.swift
//  ZellFarms
//
//  Created by mac on 25/06/2025.
//


import SwiftUI

struct CartSummaryFooter: View {
    let summaryItems: [CartSummaryModel]
    let deliveryFee: Int
    let onCheckout: () -> Void
    
    private func calculateSubtotal() -> Int {
        summaryItems.reduce(0) { $0 + ($1.price * $1.quantity) }
    }
    
    private func calculateGrandTotal() -> Int {
        calculateSubtotal() + deliveryFee
    }
    
    var body: some View {
        if !summaryItems.isEmpty {
            VStack(spacing: 10) {
                HStack {
                    Text("SubTotal")
                        .font(.system(size: 16))
                        .foregroundColor(Color(hex: 0xFFA0A0A0))
                    Spacer()
                    Text(formatPrice(String(calculateSubtotal())))
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(.primary)
                }
                
                HStack {
                    Text("Delivery Fee")
                        .font(.system(size: 16))
                        .foregroundColor(Color(hex: 0xFFA0A0A0))
                    Spacer()
                    Text(formatPrice(String(deliveryFee)))
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(.primary)
                }
                
                Divider()
                    .background(.gray)
                
                HStack {
                    Text("Grand Total")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.primary)
                    Spacer()
                    Text(formatPrice(String(calculateGrandTotal())))
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(.primary)
                }
                
                CustomButton (
                    action: onCheckout,
                    width: .infinity,
                    text: "Checkout"
                )
            }
            .padding(10)
            .padding(.bottom, 10)
            .background(Color(.systemBackground))
            .clipShape(
                RoundedRectangle(cornerRadius: 15)
                    .offset(y: -15)
            )
            .shadow(color: .black.opacity(0.1), radius: 2)
            .frame(height: 24 * 8)
        }
    }
}

// Extension to support hex colors
extension Color {
    init(hex: UInt) {
        let r = Double((hex >> 16) & 0xFF) / 255.0
        let g = Double((hex >> 8) & 0xFF) / 255.0
        let b = Double(hex & 0xFF) / 255.0
        self.init(red: r, green: b, blue: g)
    }
}
