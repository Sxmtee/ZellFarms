//
//  ProductModel.swift
//  ZellFarms
//
//  Created by mac on 17/04/2025.
//

import Foundation

// MARK: - ProductModel
struct ProductModel: Codable {
    let success: Bool
    let message: String
    let data: ProductDataClass
}

// MARK: - DataClass
struct ProductDataClass: Codable, Hashable {
    let todayChoices: [ProductCheapest]
    let limitedDiscount: [ProductCheapest]
    let cheapest: [ProductCheapest]
    let todaySpecials: [ProductCheapest]
    let flashSales: [ProductCheapest]

    enum CodingKeys: String, CodingKey {
        case flashSales = "flash_sales"
        case todaySpecials = "today_specials"
        case todayChoices = "today_choices"
        case limitedDiscount = "limited_discount"
        case cheapest
    }
}

// MARK: - Cheapest
struct ProductCheapest: Codable, Hashable {
    let id: String
    let farmID: String
    let createdBy: CreatedBy
    let categoryID: String
    let unitID: String
    let name: String
    let slug: String
    let description: String
    let deletedAt: JSONNull2?
    let createdAt: String
    let updatedAt: String
    let category: ProductCategory
    let images: [ProductImage]
    let productUnits: [ProductProductUnit]

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
struct ProductCategory: Codable, Hashable {
    let id: String
    let name: String
    let slug: String
    let imageURL: String
    let deletedAt: JSONNull2?
    let createdAt: String
    let updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id, name, slug
        case imageURL = "image_url"
        case deletedAt = "deleted_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - CreatedBy
struct CreatedBy: Codable, Hashable {
    let id: String
    let name: String // Changed from CreatedByName
    let email: String // Changed from Email
    let phone: String // Changed from Phone
    let status: String // Changed from CreatedByStatus
    let gender: String // Changed from Gender
    let dob: JSONNull2?
    let emailVerifiedAt: String? // Changed from ProductEdAt
    let deletedAt: JSONNull2?
    let createdAt: String // Changed from ProductEdAt
    let updatedAt: String // Changed from ProductEdAt

    enum CodingKeys: String, CodingKey {
        case id, name, email, phone, status, gender, dob
        case emailVerifiedAt = "email_verified_at"
        case deletedAt = "deleted_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - Image
struct ProductImage: Codable, Hashable {
    let id: String
    let uploaderID: String
    let productID: String
    let url: String
    let name: String
    let deletedAt: JSONNull2?
    let createdAt: String // Changed from ProductAtedAt
    let updatedAt: String // Changed from ProductAtedAt

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
struct ProductProductUnit: Codable, Hashable {
    let id: String
    let farmID: String
    let productID: String
    let unitID: String
    let pricePerUnit: Int
    let unitNumber: Int
    let stock: Int
    let status: String // Changed from ProductUnitStatus
    let deletedAt: JSONNull2?
    let createdAt: String // Changed from ProductAtedAt
    let updatedAt: String // Changed from ProductAtedAt
    let availableQuantity: Int
    let unit: ProductUnits

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
struct ProductUnits: Codable, Hashable {
    let id: String
    let name: String // Changed from UnitName
    let symbol: String // Changed from Symbol
    let conversionFactor: String
    let deletedAt: JSONNull2?
    let createdAt: String // Changed from ProductEdAt
    let updatedAt: String // Changed from ProductEdAt

    enum CodingKeys: String, CodingKey {
        case id, name, symbol
        case conversionFactor = "conversion_factor"
        case deletedAt = "deleted_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - Encode/decode helpers
class JSONNull2: Codable, Hashable {
    public static func == (lhs: JSONNull2, rhs: JSONNull2) -> Bool {
        return true
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(0)
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull2.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull2"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
