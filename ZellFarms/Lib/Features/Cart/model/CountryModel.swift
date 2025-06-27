//
//  Country.swift
//  ZellFarms
//
//  Created by mac on 27/06/2025.
//


import Foundation

struct CountryModel: Codable {
    let success: Bool
    let message: String
    let data: [Country]
}

struct Country: Hashable, Codable, Identifiable {
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


struct StateModel: Codable {
    let success: Bool
    let message: String
    let data: [States]
}

struct States: Hashable, Codable, Identifiable {
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
