//
//  DeliveryResponse.swift
//  ZellFarms
//
//  Created by mac on 25/06/2025.
//


import Foundation

// MARK: - DeliveryResponse
struct DeliveryResponse: Codable {
    let success: Bool
    let message: String
    let data: [DeliveryChannel]
}

// MARK: - DeliveryChannel
struct DeliveryChannel: Codable, Identifiable {
    let id: String
    let name: String
    let description: String
    let fee: String?
    let isDistanceBased: Bool
    let feePerKm: String?
    let deletedAt: String?
    let createdAt: String
    let updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id, name, description, fee
        case isDistanceBased = "is_distance_based"
        case feePerKm = "fee_per_km"
        case deletedAt = "deleted_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
