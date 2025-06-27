//
//  OrderSummaryView.swift
//  ZellFarms
//
//  Created by mac on 27/06/2025.
//

import SwiftUI

// MARK: - Order Summary View
struct OrderSummaryView: View {
    let totalFees: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Order Summary")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.primary)
            
            HStack {
                Text("Total")
                    .font(.system(size: 16))
                    .foregroundColor(Color(hex: 0xFFA0A0A0))
                Spacer()
                Text(formatPrice(String(totalFees)))
                    .font(.system(size: 17, weight: .medium))
                    .foregroundColor(.primary)
            }
        }
        .padding(.bottom, 15)
    }
}

// MARK: - Delivery Channel View
struct DeliveryChannelView: View {
    let isLoading: Bool
    let deliveryChannels: [DeliveryChannel]
    @Binding var selectedDeliveryChannel: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Delivery Channel")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.primary)
            
            if isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
            } else {
                ForEach(deliveryChannels) { channel in
                    SelectionCard(
                        emoji: channel.name == "Standard Delivery" ? "🚛" : "🏎️",
                        name: channel.name,
                        description: channel.description,
                        isSelected: selectedDeliveryChannel == channel.id
                    )
                    .onTapGesture {
                        selectedDeliveryChannel = channel.id
                    }
                }
            }
        }
        .padding(.bottom, 15)
    }
}

// MARK: - Payment Method View
struct PaymentMethodView: View {
    let paymentChannels: [PaymentChannel]
    @Binding var selectedPaymentChannel: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Payment Method")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.primary)
            
            ForEach(paymentChannels) { channel in
                SelectionCard(
                    emoji: channel.name == "Pay on Delivery" ? "💰" : "💳",
                    name: channel.name,
                    description: channel.description,
                    isSelected: selectedPaymentChannel == channel.id
                )
                .onTapGesture {
                    selectedPaymentChannel = channel.id
                }
            }
        }
        .padding(.bottom, 15)
    }
}

// MARK: - Delivery Address View
struct DeliveryAddressView: View {
    let address: Address?
    let isLoading: Bool
    @Binding var selectedAddress: String?
    @Binding var addressToDelete: String?
    @Binding var showDeleteConfirmation: Bool
    
    @Environment(Router.self) private var router
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text("Delivery Address")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.primary)
                
                Spacer()
                
                Button {
                    router.push(.addLocation)
                } label: {
                    Image(systemName: "pencil")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(Color(hex: 0xFFA0A0A0))
                }
            }
            
            if isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
            } else if address == nil {
                VStack {
                    Image(systemName: "mappin.slash.circle")
                        .font(.system(size: 50))
                        .foregroundColor(Color(hex: 0xFF6200EE))
                    Text("No locations available\nAdd a location")
                        .multilineTextAlignment(.center)
                        .font(.system(size: 16))
                        .foregroundColor(Color(hex: 0xFF6200EE))
                        .padding(.vertical, 10)
                }
                .frame(maxWidth: .infinity)
            } else {
                ZStack {
                    SelectionCard(
                        emoji: "🌍",
                        name: "\(address!.streetNo), \(address!.address)",
                        description: "\(address!.city), \(address!.state.name) State",
                        isSelected: selectedAddress == address!.id
                    )
                    .onTapGesture {
                        selectedAddress = address!.id
                    }
                    
                    HStack {
                        Spacer()
                        Button {
                            addressToDelete = address!.id
                            showDeleteConfirmation = true
                        } label: {
                            Image(systemName: "trash")
                                .font(.system(size: 16))
                                .foregroundColor(.red)
                                .padding(.trailing, 10)
                        }
                    }
                }
            }
        }
        .padding(.bottom, 15)
    }
}

// MARK: - Shipment View
struct ShipmentView: View {
    let cartItems: [CartSummaryModel]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Shipments")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.primary)
            
            ForEach(cartItems, id: \.id) { item in
                HStack(alignment: .top, spacing: 10) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color(.systemBackground))
                            .shadow(radius: 2)
                        
                        Text("🥘")
                            .font(.system(size: 70))
                    }
                    .frame(width: 100, height: 100)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text(item.name)
                            .font(.system(size: 15, weight: .bold))
                            .lineLimit(2)
                        
                        Text(formatPrice(String(item.price)))
                            .font(.system(size: 15, weight: .semibold))
                            .lineLimit(2)
                        
                        Text("Quantity: \(item.quantity)")
                            .font(.system(size: 15, weight: .medium))
                    }
                }
                .padding(8)
                .background(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 15))
            }
        }
        .padding(.bottom, 15)
    }
}
