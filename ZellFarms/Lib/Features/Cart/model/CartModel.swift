//
//  CartModel.swift
//  ZellFarms
//
//  Created by mac on 20/06/2025.
//

// CartModel.swift

import Foundation

// MARK: - CartModel
struct CartModel: Codable, Hashable {
    let success: Bool
    let message: String
    let data: Cart
}

// MARK: - CartData
struct Cart: Codable, Hashable {
    let id, userID, status, cartToken: String
    let deletedAt: CartJSONNull?
    let createdAt, updatedAt: String
    let items: [CartItem]

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case status
        case cartToken = "cart_token"
        case deletedAt = "deleted_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case items
    }
}

// MARK: - CartItem
struct CartItem: Codable, Hashable {
    let id, cartID, productID, productUnitID: String
    let quantity: Int
    let pricePerUnit: String
    let status: String
    let deletedAt: CartJSONNull?
    let createdAt, updatedAt: String
    let productUnit: CartProductUnitDetail

    enum CodingKeys: String, CodingKey {
        case id
        case cartID = "cart_id"
        case productID = "product_id"
        case productUnitID = "product_unit_id"
        case quantity
        case pricePerUnit = "price_per_unit"
        case status
        case deletedAt = "deleted_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case productUnit = "product_unit"
    }
}

// MARK: - ProductUnitDetails
struct CartProductUnitDetail: Codable, Hashable {
    let id, farmID, productID, unitID: String
    let pricePerUnit, unitNumber, stock: Int
    let status: String
    let deletedAt: CartJSONNull?
    let createdAt, updatedAt: String
    let availableQuantity: Int
    let unit: Unit
    let product: CartProduct

    enum CodingKeys: String, CodingKey {
        case id
        case farmID = "farm_id"
        case productID = "product_id"
        case unitID = "unit_id"
        case pricePerUnit = "price_per_unit"
        case unitNumber = "unit_number"
        case stock
        case status
        case deletedAt = "deleted_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case availableQuantity = "available_quantity"
        case unit
        case product
    }
}

// MARK: - Unit
struct CartUnit: Codable, Hashable {
    let id, name, symbol, conversionFactor: String
    let deletedAt: CartJSONNull?
    let createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id, name, symbol
        case conversionFactor = "conversion_factor"
        case deletedAt = "deleted_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - Product
struct CartProduct: Codable, Hashable {
    let id, farmID, createdBy, categoryID: String
    let unitID, name, slug, description: String
    let deletedAt: CartJSONNull?
    let createdAt, updatedAt: String

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
    }
}


// MARK: - JSONNull (unchanged)
class CartJSONNull: Codable, Hashable {
    static func == (lhs: CartJSONNull, rhs: CartJSONNull) -> Bool {
        return true // All JSONNull instances are equal
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(0)
    }
    
    init() {}
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
