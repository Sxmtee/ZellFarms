//
//  CartRepo.swift
//  ZellFarms
//
//  Created by mac on 16/06/2025.
//

import Foundation
import SwiftyNetworking

@Observable
class CartRepo {
    var cartItems: [CartItem] = []
    var deliveryChannels: [DeliveryChannel] = []
    var countries: [Country] = []
    var states: [States] = []
    
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
                headers: ["Authorization": "Bearer \(token)"]
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
    
    func getCountries() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let request = try SwiftyNetworkingRequest(
                url: URL(string: "\(baseUrl)/countries"),
                method: .get
            )
            
            let (data, _) = try await ServiceCall.performRequest(request)
            
            let decoder = JSONDecoder()
            let country = try decoder.decode(CountryModel.self, from: data)
            
            successMessage = country.message.isEmpty ? "Countries loaded successfully" : country.message

            countries = country.data
        } catch {
            self.error = "An unexpected error occurred: \(error.localizedDescription)"
        }
    }
    
    func getState() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let request = try SwiftyNetworkingRequest(
                url: URL(string: "\(baseUrl)/states"),
                method: .get
            )
            
            let (data, _) = try await ServiceCall.performRequest(request)
            
            let decoder = JSONDecoder()
            let state = try decoder.decode(StateModel.self, from: data)
            
            successMessage = state.message.isEmpty ? "States loaded successfully" : state.message

            states = state.data
        } catch {
            self.error = "An unexpected error occurred: \(error.localizedDescription)"
        }
    }
    
    func createAddress(
        countryId: String,
        stateId: String,
        streetNo: String,
        landmark: String,
        address: String,
        city: String,
        zipCode: String
    ) async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let token = ZelPreferences.accessToken
            
            let body: [String: Any] = [
                "country_id": countryId,
                "state_id": stateId,
                "street_no": streetNo,
                "nearest_landmark": landmark,
                "address": address,
                "city": city,
                "zip_code": zipCode,
            ]
            
            let bodyData = try JSONSerialization.data(withJSONObject: body)
            
            let request = try SwiftyNetworkingRequest(
                url: URL(string: "\(baseUrl)/address"),
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
    
    func getAddress() async -> Address? {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let token = ZelPreferences.accessToken
            
            let request = try SwiftyNetworkingRequest(
                url: URL(string: "\(baseUrl)/address"),
                method: .get,
                headers: ["Authorization": "Bearer \(token)"]
            )
            
            let (data, _) = try await ServiceCall.performRequest(request)
            
            let decoder = JSONDecoder()
            let address = try decoder.decode(AddressModel.self, from: data)
            
            successMessage = address.message.isEmpty ? "Address loaded successfully" : address.message
            
            return address.data
        } catch {
            self.error = "An unexpected error occurred: \(error.localizedDescription)"
            return nil
        }
    }
    
    func deleteAddress(id: String) async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let token = ZelPreferences.accessToken
            
            let request = try SwiftyNetworkingRequest(
                url: URL(string: "\(baseUrl)/address/\(id)"),
                method: .delete,
                headers: ["Authorization": "Bearer \(token)"]
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
    
    func createOrder(
        deliveryChannelId: String,
        paymentChannel: String,
        addressId: String,
        deliveryFee: Int,
        cartData: [CartData]
    ) async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let token = ZelPreferences.accessToken
            
            let orderData = try cartData.map { try $0.toDictionary() }
            
            let body: [String: Any] = [
                "delivery_channel_id": deliveryChannelId,
                "payment_method": paymentChannel,
                "address_id": addressId,
                "delivery_fee": deliveryFee,
                "order_data": orderData
            ]
            
            let bodyData = try JSONSerialization.data(withJSONObject: body)
            
            let request = try SwiftyNetworkingRequest(
                url: URL(string: "\(baseUrl)/address"),
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
}
