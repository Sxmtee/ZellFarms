//
//  CartScreen.swift
//  ZellFarms
//
//  Created by mac on 16/06/2025.
//

import SwiftUI

struct CartScreen: View {
    @State private var cartRepo = CartRepo()
    @State private var summaryItems: [CartSummaryModel] = []
    let deliveryFee: Int = 4500
    
    private func calculateSubtotal() -> Int {
        summaryItems.reduce(0) { $0 + ($1.price * $1.quantity) }
    }
    
    // Calculate grand total (subtotal + delivery fee)
    private func calculateGrandTotal() -> Int {
        calculateSubtotal() + deliveryFee
    }
    
    private func mapToSummaryItems(_ cartItems: [CartItem]) -> [CartSummaryModel] {
        cartItems.map { item in
            CartSummaryModel(
                id: item.productID,
                name: item.productUnit.product.name,
                price: item.productUnit.pricePerUnit,
                quantity: item.quantity,
                productId: item.productUnitID,
                unitName: item.productUnit.unit.name
            )
        }
    }
    
    private func refreshCart() async {
        await cartRepo.getCart()
        summaryItems = mapToSummaryItems(cartRepo.cartItems)
    }
    
    var body: some View {
        VStack {
            if cartRepo.isLoading {
                ProgressView()
            } else {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 15) {
                        if summaryItems.isEmpty {
                            VStack {
                                Image(systemName: "cart")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 80, height: 80)
                                    .foregroundColor(.gray)
                                    .padding(.bottom, 20)
                                
                                Text("Your cart is empty")
                                    .font(.system(size: 20, weight: .medium))
                                    .foregroundColor(.gray)
                                    .padding(.bottom, 10)
                                
                                Text("Add some items to get started!")
                                    .font(.system(size: 16))
                                    .foregroundColor(.gray)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        } else {
                            ForEach(Array(summaryItems.enumerated()), id: \.element.id) { index, item in
                                CartProductCard(
                                    item: item,
                                    onDelete: {
                                        let itemId = item.id
                                        summaryItems.remove(at: index)
                                        
                                        await cartRepo.deleteCart(id: itemId)
                                        await refreshCart()
                                    },
                                    onQuantityChange: { increase in
                                        if increase {
                                            summaryItems[index].quantity += 1
                                        } else if item.quantity > 1 {
                                            summaryItems[index].quantity -= 1
                                        }
                                    }
                                )
                            }
                        }
                    }
                    .padding(10)
                }
                .scrollBounceBehavior(.basedOnSize)
                .safeAreaInset(edge: .bottom) {
                    CartSummaryFooter(
                        summaryItems: summaryItems,
                        deliveryFee: deliveryFee
                    ) {
                        //checkout
                    }
                }
            }
        }
        .ignoresSafeArea(edges: .bottom)
        .navigationTitle("Cart Summary")
        .task {
            await refreshCart()
        }
        .snackbar(
            isShowing: $cartRepo.showErrorSnackbar,
            message: cartRepo.error ?? ""
        )
        .snackbar(
            isShowing: $cartRepo.showSuccessSnackbar,
            message: cartRepo.successMessage ?? "",
            isSuccess: true
        )
    }
}
