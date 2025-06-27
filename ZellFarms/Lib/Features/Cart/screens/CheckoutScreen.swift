//
//  CheckoutScreen.swift
//  ZellFarms
//
//  Created by mac on 25/06/2025.
//

import SwiftUI

struct CheckoutScreen: View {
    let cartSummary: [CartSummaryModel]
    let totalFees: Int
    
    @Environment(Router.self) private var router
    @State private var cartData: [CartData] = []
    @State private var cartRepo = CartRepo()
    @State private var address: Address?
    @State private var selectedDeliveryChannel: String?
    @State private var selectedPaymentChannel: String?
    @State private var selectedAddress: String?
    @State private var showDeleteConfirmation: Bool = false
    @State private var addressToDelete: String?
    
    private func mapToCartData(_ cartSummary: [CartSummaryModel]) -> [CartData] {
        cartSummary.map { item in
            CartData(
                productId: item.id,
                productUnits: [
                    CartProductUnits(
                        productUnitId: item.productId,
                        quantity: item.quantity
                    )
                ]
            )
        }
    }
    
    private let paymentChannels: [PaymentChannel] = [
        PaymentChannel(
            id: "Pay Online",
            name: "Pay Online",
            description: "You will be sent a mail for further instructions"
        ),
        PaymentChannel(
            id: "Pay on Delivery",
            name: "Pay on Delivery",
            description: "Pay when the goods are delivered to you"
        )
    ]
    
    private func createOrder() {
        if selectedDeliveryChannel == nil || selectedPaymentChannel == nil || selectedAddress == nil {
            cartRepo.error = "Please choose all necessary details"
            return
        }
        
        Task {
            await cartRepo.createOrder(
                deliveryChannelId: selectedDeliveryChannel!,
                paymentChannel: selectedPaymentChannel! == "Pay on Delivery" ? "bank_transfer" : "bank_transfer",
                addressId: selectedAddress!,
                deliveryFee: 4500,
                cartData: cartData
            )
            
            if cartRepo.error == nil {
                await MainActor.run {
                    router.pop()
                }
            }
        }
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading) {
                OrderSummaryView(totalFees: totalFees)
                
                DeliveryChannelView(
                    isLoading: cartRepo.isLoading,
                    deliveryChannels: cartRepo.deliveryChannels,
                    selectedDeliveryChannel: $selectedDeliveryChannel
                )
                
                PaymentMethodView(
                    paymentChannels: paymentChannels,
                    selectedPaymentChannel: $selectedPaymentChannel
                )
                
                DeliveryAddressView(
                    address: address,
                    isLoading: cartRepo.isLoading,
                    selectedAddress: $selectedAddress,
                    addressToDelete: $addressToDelete,
                    showDeleteConfirmation: $showDeleteConfirmation
                )
                
                ShipmentView(cartItems: cartSummary)
                
                Button{
                    router.pop()
                } label: {
                    Text("Go back & continue shopping")
                        .font(.system(size: 16))
                        .foregroundColor(Color(hex: 0xFF6200EE))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                }
                
                CustomButton(
                    action: {
                        createOrder()
                    },
                    width: .infinity,
                    text: "Confirm Order"
                )
            }
        }
        .padding(15)
        .navigationTitle("Checkout")
        .task {
            await cartRepo.getDeliveryChannel()
            address = await cartRepo.getAddress()
        }
        .onAppear {
            cartData = mapToCartData(cartSummary)
        }
        .alert("Delete Address", isPresented: $showDeleteConfirmation, actions: {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                if let id = addressToDelete {
                    Task {
                        await cartRepo.deleteAddress(id: id)
                        if cartRepo.error == nil {
                            address = await cartRepo.getAddress()
                        }
                    }
                }
            }
        }, message: {
            Text("Are you sure you want to delete this address?")
        })
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
