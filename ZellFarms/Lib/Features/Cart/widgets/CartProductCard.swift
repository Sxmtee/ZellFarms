//
//  CartProductCard.swift
//  ZellFarms
//
//  Created by mac on 20/06/2025.
//

import SwiftUI

struct CartProductCard: View {
    let item: CartSummaryModel
    let onDelete: () async throws -> Void
    let onQuantityChange: (Bool) -> Void
    
    @State private var showingDeleteAlert = false
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color(.systemBackground))
                    .shadow(radius: 2)
                
                Text("🥘")
                    .font(.system(size: 50))
            }
            .frame(width: 100, height: 100)
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(item.name)
                        .font(.system(size: 15, weight: .bold))
                        .lineLimit(2)
                    
                    Spacer()
                    
                    Button {
                        showingDeleteAlert = true
                    } label: {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                    }
                }
                
                Text("Unit Price/per \(item.unitName)")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                
                HStack {
                    Text(formatPrice(String(item.price * item.quantity)))
                        .font(.system(size: 15, weight: .bold))
                        .lineLimit(2)
                    
                    Spacer()
                    
                    HStack(spacing: 0) {
                        Button {
                            Task { onQuantityChange(false) }
                        } label: {
                            Image(systemName: "minus.circle")
                                .foregroundColor(.gray)
                        }
                        
                        Text("\(item.quantity)")
                            .frame(minWidth: 40)
                            .font(.system(size: 16))
                        
                        Button {
                            Task { onQuantityChange(true) }
                        } label: {
                            Image(systemName: "plus.circle")
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
        }
        .padding(8)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .padding(.bottom, 10)
        .alert("Delete Product", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive) {
                Task { try? await onDelete() }
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Delete this product from the cart")
        }
    }
}
