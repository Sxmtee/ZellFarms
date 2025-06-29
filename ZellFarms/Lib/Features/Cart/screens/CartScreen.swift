//
//  CartScreen.swift
//  ZellFarms
//
//  Created by mac on 16/06/2025.
//

import SwiftUI

struct CartScreen: View {
    @Environment(Router.self) private var router
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
        if ZelPreferences.accessToken.isEmpty {
            return cartRepo.localCartItems.map { item in
                CartSummaryModel(
                    id: item.productId,
                    name: item.name,
                    price: item.price,
                    quantity: item.quantity,
                    productId: item.productUnitId,
                    unitName: item.unitName
                )
            }
        } else {
            return cartItems.map { item in
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
    }
    
    private func refreshCart() async {
        await cartRepo.getCart()
        summaryItems = mapToSummaryItems(cartRepo.cartItems)
    }
    
    private var emptyCartView: some View {
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
    }
    
    private func cartItemsView() -> some View {
        ForEach(Array(summaryItems.enumerated()), id: \.element.id) { index, item in
            CartProductCard(
                item: item,
                onDelete: {
                    if ZelPreferences.accessToken.isEmpty {
                        cartRepo.localCartItems.removeAll { $0.productId == item.id }
                        summaryItems = mapToSummaryItems(cartRepo.cartItems)
                    } else {
                        Task {
                            await cartRepo.deleteCart(id: item.id)
                            await refreshCart()
                        }
                    }
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
    
    private var footerView: some View {
        CartSummaryFooter(
            summaryItems: summaryItems,
            deliveryFee: deliveryFee
        ) {
            if ZelPreferences.accessToken.isEmpty {
                router.push(.authScreen)
            } else {
                router.replace(
                    .checkoutscreen(
                        cartSummary: summaryItems,
                        totalFees: calculateGrandTotal()
                    )
                )
            }
        }
    }
    
    var body: some View {
        VStack {
            if cartRepo.isLoading {
                ProgressView()
            } else {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 15) {
                        if summaryItems.isEmpty {
                            emptyCartView
                        } else {
                            cartItemsView()
                        }
                    }
                    .padding(10)
                }
                .scrollBounceBehavior(.basedOnSize)
                .safeAreaInset(edge: .bottom) {
                    footerView
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
        .environment(router)
    }
}
