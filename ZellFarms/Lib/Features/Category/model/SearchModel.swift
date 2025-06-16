//
//  SearchModel.swift
//  ZellFarms
//
//  Created by mac on 28/04/2025.
//

import Foundation

// MARK: - SearchModel
struct SearchModel: Codable {
    let success: Bool
    let message: String
    let data: [SearchData]
}

// MARK: - Datum
struct SearchData: Codable, Hashable {
    let id, farmID: String
    let createdBy: SearchCreatedBy
    let categoryID, unitID, name, slug: String
    let description: String
    let deletedAt: SearchJSONNull?
    let createdAt, updatedAt: String
    let category: SearchCategory
    let images: [SearchImage]
    let productUnits: [SearchProductUnit]

    enum CodingKeys: String, CodingKey {
        case id
        case farmID = "farm_id"
        case createdBy = "created_by"
        case categoryID = "category_id"
        case unitID = "unit_id"
        case name, slug, description
        case deletedAt = "deleted_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case category, images
        case productUnits = "product_units"
    }
}

// MARK: - Category
struct SearchCategory: Codable, Hashable {
    let id, name, slug: String
    let imageURL: String
    let deletedAt: SearchJSONNull?
    let createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id, name, slug
        case imageURL = "image_url"
        case deletedAt = "deleted_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - CreatedBy
struct SearchCreatedBy: Codable, Hashable {
    let id, name, email, phone: String
    let status, gender: String
    let dob: SearchJSONNull?
    let emailVerifiedAt: String
    let deletedAt: SearchJSONNull?
    let createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id, name, email, phone, status, gender, dob
        case emailVerifiedAt = "email_verified_at"
        case deletedAt = "deleted_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - Image
struct SearchImage: Codable, Hashable {
    let id, uploaderID, productID: String
    let url: String
    let name: String
    let deletedAt: SearchJSONNull?
    let createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case uploaderID = "uploader_id"
        case productID = "product_id"
        case url, name
        case deletedAt = "deleted_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - ProductUnit
struct SearchProductUnit: Codable, Hashable {
    let id, farmID, productID, unitID: String
    let pricePerUnit, unitNumber, stock: Int
    let status: String
    let deletedAt: SearchJSONNull?
    let createdAt, updatedAt: String
    let availableQuantity: Int
    let unit: SearchUnit

    enum CodingKeys: String, CodingKey {
        case id
        case farmID = "farm_id"
        case productID = "product_id"
        case unitID = "unit_id"
        case pricePerUnit = "price_per_unit"
        case unitNumber = "unit_number"
        case stock, status
        case deletedAt = "deleted_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case availableQuantity = "available_quantity"
        case unit
    }
}

// MARK: - Unit
struct SearchUnit: Codable, Hashable {
    let id, name, symbol, conversionFactor: String
    let deletedAt: SearchJSONNull?
    let createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id, name, symbol
        case conversionFactor = "conversion_factor"
        case deletedAt = "deleted_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - Encode/decode helpers

class SearchJSONNull: Codable, Hashable {
    static func == (lhs: SearchJSONNull, rhs: SearchJSONNull) -> Bool {
        return true // All JSONNull instances are equal
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(0)
    }
    
    init() {}
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(
                SearchJSONNull.self, DecodingError.Context(
                    codingPath: decoder.codingPath,
                    debugDescription: "Wrong type for JSONNull"
                )
            )
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

