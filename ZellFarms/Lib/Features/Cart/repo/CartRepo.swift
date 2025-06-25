//
//  CartRepo.swift
//  ZellFarms
//
//  Created by mac on 16/06/2025.
//

import Foundation
import SwiftyNetworking
import UIKit

@Observable
class CartRepo {
    var cartItems: [CartItem] = []
    var deliveryChannels: [DeliveryChannel] = []
    
    var showErrorSnackbar = false
    var showSuccessSnackbar = false
    var isLoading = false
    
    var error: String? {
        didSet {
            if error != nil {
                showErrorSnackbar = true
            }
        }
    }
    var successMessage: String? {
        didSet {
            if successMessage != nil {
                showSuccessSnackbar = true
                showErrorSnackbar = false
            }
        }
    }
    
    func createCart(cartData: [CartData]) async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let token = ZelPreferences.accessToken
            
            let payload = ["cart_data": cartData]
            let bodyData = try JSONEncoder().encode(payload)
            
            let request = try SwiftyNetworkingRequest(
                url: URL(string: "\(baseUrl)/cart"),
                method: .post,
                headers: [
                    "Content-Type": "application/json",
                    "Authorization": "Bearer \(token)"
                ],
                body: bodyData
            )
            
            let (data, _) = try await ServiceCall.performRequest(request)
            
            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
            
            if let message = json?["message"] as? String {
                await MainActor.run {
                    self.successMessage = message
                }
            }
        } catch {
            self.error = "An unexpected error occurred: \(error.localizedDescription)"
        }
    }
    
    func getCart() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let token = ZelPreferences.accessToken
            
            let request = try SwiftyNetworkingRequest(
                url: URL(string: "\(baseUrl)/cart"),
                method: .get,
                headers: ["Authorization": "Bearer \(token)"]
            )
            
            let (data, _) = try await ServiceCall.performRequest(request)
            
            let decoder = JSONDecoder()
            let cartResponse = try decoder.decode(CartModel.self, from: data)
            
            successMessage = cartResponse.message.isEmpty ? "Cart loaded successfully" : cartResponse.message
            
            cartItems = cartResponse.data.items
        } catch {
            self.error = "An unexpected error occurred: \(error.localizedDescription)"
        }
    }
    
    func deleteCart(id: String) async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let token = ZelPreferences.accessToken
            
            let request = try SwiftyNetworkingRequest(
                url: URL(string: "\(baseUrl)/cart/\(id)"),
                method: .delete,
                headers: [
                    "Content-Type": "application/json",
                    "Authorization": "Bearer \(token)"
                ]
            )
            
            let (data, _) = try await ServiceCall.performRequest(request)
            
            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
            
            if let message = json?["message"] as? String {
                await MainActor.run {
                    self.successMessage = message
                }
            }
        } catch {
            self.error = "An unexpected error occurred: \(error.localizedDescription)"
        }
    }
    
    func getDeliveryChannel() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let request = try SwiftyNetworkingRequest(
                url: URL(string: "\(baseUrl)/delivery-channel"),
                method: .get
            )
            
            let (data, _) = try await ServiceCall.performRequest(request)
            
            let decoder = JSONDecoder()
            let deliveryResponse = try decoder.decode(DeliveryResponse.self, from: data)
            
            successMessage = deliveryResponse.message.isEmpty ? "Delivery loaded successfully" : deliveryResponse.message
            
            deliveryChannels = deliveryResponse.data
        } catch {
            self.error = "An unexpected error occurred: \(error.localizedDescription)"
        }
    }
}
