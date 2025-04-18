// CategoryModel.swift
import Foundation

// MARK: - CategoryModel
struct CategoryModel: Codable, Hashable {
    let success: Bool
    let message: String
    let data: [Categories]
}

// MARK: - Categories
struct Categories: Codable, Hashable {
    let id, name, slug: String
    let imageURL: String
    let deletedAt: JSONNull?
    let createdAt, updatedAt: AtedAt
    let products: [Product]

    enum CodingKeys: String, CodingKey {
        case id, name, slug
        case imageURL = "image_url"
        case deletedAt = "deleted_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case products
    }
}

// MARK: - AtedAt
enum AtedAt: String, Codable, Hashable {
    case the20250115T100551000000Z = "2025-01-15T10:05:51.000000Z"
    case the20250115T100552000000Z = "2025-01-15T10:05:52.000000Z"
}

// MARK: - Product
struct Product: Codable, Hashable {
    let id, farmID, createdBy, categoryID: String
    let unitID, name, slug, description: String
    let deletedAt: JSONNull?
    let createdAt, updatedAt: String
    let images: [Images]
    let productUnits: [ProductUnit]

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
        case images
        case productUnits = "product_units"
    }
}

// MARK: - Images
struct Images: Codable, Hashable {
    let id, uploaderID, productID: String
    let url, name: String
    let deletedAt: JSONNull?
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
struct ProductUnit: Codable, Hashable {
    let id, farmID, productID, unitID: String
    let pricePerUnit, unitNumber, stock: Int
    let status: String
    let deletedAt: JSONNull?
    let createdAt, updatedAt: String
    let unit: Unit

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
        case unit
    }
}

// MARK: - Unit
struct Unit: Codable, Hashable {
    let id, name, symbol, conversionFactor: String
    let deletedAt: JSONNull?
    let createdAt, updatedAt: AtedAt

    enum CodingKeys: String, CodingKey {
        case id, name, symbol
        case conversionFactor = "conversion_factor"
        case deletedAt = "deleted_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - JSONNull (unchanged)
class JSONNull: Codable, Hashable {
    static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
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
