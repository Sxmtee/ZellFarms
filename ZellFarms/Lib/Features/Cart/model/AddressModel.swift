//
//  Address.swift
//  ZellFarms
//
//  Created by mac on 27/06/2025.
//


import Foundation

struct AddressModel: Codable {
    let success: Bool
    let message: String
    let data: Address
}

struct Address: Codable, Hashable, Identifiable {
    let id: String
    let userID: String
    let countryID: String
    let stateID: String
    let streetNo: String
    let nearestLandmark: String
    let address: String
    let city: String
    let zipCode: String
    let deletedAt: String?
    let createdAt: String
    let updatedAt: String
    let country: UserCountry
    let state: UserState

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case countryID = "country_id"
        case stateID = "state_id"
        case streetNo = "street_no"
        case nearestLandmark = "nearest_landmark"
        case address
        case city
        case zipCode = "zip_code"
        case deletedAt = "deleted_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case country
        case state
    }
}

struct UserCountry: Codable, Hashable, Identifiable {
    let id: String
    let name: String
    let deletedAt: String?
    let createdAt: String
    let updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case deletedAt = "deleted_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

struct UserState: Codable, Hashable, Identifiable {
    let id: String
    let name: String
    let deletedAt: String?
    let createdAt: String
    let updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case deletedAt = "deleted_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
