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
    let todayChoices, limitedDiscount, cheapest, todaySpecials, flashSales: [ProductCheapest]

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
    let id, farmID: String
    let createdBy: CreatedBy
    let categoryID, unitID, name, slug: String
    let description: String
    let deletedAt: JSONNull2?
    let createdAt, updatedAt: ProductAtedAt
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
    let id, name, slug: String
    let imageURL: String
    let deletedAt: JSONNull?
    let createdAt, updatedAt: ProductEdAt

    enum CodingKeys: String, CodingKey {
        case id, name, slug
        case imageURL = "image_url"
        case deletedAt = "deleted_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

enum ProductEdAt: String, Codable, Hashable {
    case the20250115T100551000000Z = "2025-01-15T10:05:51.000000Z"
    case the20250115T100552000000Z = "2025-01-15T10:05:52.000000Z"
}

enum ProductAtedAt: String, Codable, Hashable {
    case the20250115T112704000000Z = "2025-01-15T11:27:04.000000Z"
    case the20250115T112836000000Z = "2025-01-15T11:28:36.000000Z"
    case the20250115T113004000000Z = "2025-01-15T11:30:04.000000Z"
    case the20250115T165756000000Z = "2025-01-15T16:57:56.000000Z"
    case the20250327T024902000000Z = "2025-03-27T02:49:02.000000Z"
}

// MARK: - CreatedBy
struct CreatedBy: Codable, Hashable {
    let id: String
    let name: CreatedByName
    let email: Email
    let phone: Phone
    let status: CreatedByStatus
    let gender: Gender
    let dob: JSONNull?
    let emailVerifiedAt: ProductEdAt
    let deletedAt: JSONNull?
    let createdAt, updatedAt: ProductEdAt

    enum CodingKeys: String, CodingKey {
        case id, name, email, phone, status, gender, dob
        case emailVerifiedAt = "email_verified_at"
        case deletedAt = "deleted_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

enum Email: String, Codable, Hashable {
    case zelfarmsNgGmailCOM = "zelfarms.ng@gmail.com "
}

enum Gender: String, Codable, Hashable {
    case male = "male"
}

enum CreatedByName: String, Codable, Hashable {
    case superAdmin = "Super Admin"
}

enum Phone: String, Codable, Hashable {
    case the5513653079 = "551-365-3079"
}

enum CreatedByStatus: String, Codable, Hashable {
    case active = "active"
}

// MARK: - Image
struct ProductImage: Codable, Hashable {
    let id, uploaderID, productID: String
    let url: String
    let name: String
    let deletedAt: JSONNull2?
    let createdAt, updatedAt: ProductAtedAt

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
    let id, farmID, productID, unitID: String
    let pricePerUnit, unitNumber, stock: Int
    let status: ProductUnitStatus
    let deletedAt: JSONNull2?
    let createdAt, updatedAt: ProductAtedAt
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

enum ProductUnitStatus: String, Codable, Hashable {
    case available = "available"
}

// MARK: - Unit
struct ProductUnits: Codable, Hashable {
    let id: String
    let name: UnitName
    let symbol: Symbol
    let conversionFactor: String
    let deletedAt: JSONNull2?
    let createdAt, updatedAt: ProductEdAt

    enum CodingKeys: String, CodingKey {
        case id, name, symbol
        case conversionFactor = "conversion_factor"
        case deletedAt = "deleted_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

enum UnitName: String, Codable, Hashable {
    case gram = "Gram"
    case kilogram = "Kilogram"
    case liter = "Liter"
}

enum Symbol: String, Codable, Hashable {
    case g = "G"
    case kg = "KG"
    case l = "L"
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

class JSONCodingKey: CodingKey {
    let key: String

    required init?(intValue: Int) {
        return nil
    }

    required init?(stringValue: String) {
        key = stringValue
    }

    var intValue: Int? {
        return nil
    }

    var stringValue: String {
        return key
    }
}

class JSONAny: Codable {
    let value: Any

    static func decodingError(forCodingPath codingPath: [CodingKey]) -> DecodingError {
        let context = DecodingError.Context(codingPath: codingPath, debugDescription: "Cannot decode JSONAny")
        return DecodingError.typeMismatch(JSONAny.self, context)
    }

    static func encodingError(forValue value: Any, codingPath: [CodingKey]) -> EncodingError {
        let context = EncodingError.Context(codingPath: codingPath, debugDescription: "Cannot encode JSONAny")
        return EncodingError.invalidValue(value, context)
    }

    static func decode(from container: SingleValueDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if container.decodeNil() {
            return JSONNull2()
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout UnkeyedDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if let value = try? container.decodeNil() {
            if value {
                return JSONNull2()
            }
        }
        if var container = try? container.nestedUnkeyedContainer() {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout KeyedDecodingContainer<JSONCodingKey>, forKey key: JSONCodingKey) throws -> Any {
        if let value = try? container.decode(Bool.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Int64.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Double.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(String.self, forKey: key) {
            return value
        }
        if let value = try? container.decodeNil(forKey: key) {
            if value {
                return JSONNull2()
            }
        }
        if var container = try? container.nestedUnkeyedContainer(forKey: key) {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decodeArray(from container: inout UnkeyedDecodingContainer) throws -> [Any] {
        var arr: [Any] = []
        while !container.isAtEnd {
            let value = try decode(from: &container)
            arr.append(value)
        }
        return arr
    }

    static func decodeDictionary(from container: inout KeyedDecodingContainer<JSONCodingKey>) throws -> [String: Any] {
        var dict = [String: Any]()
        for key in container.allKeys {
            let value = try decode(from: &container, forKey: key)
            dict[key.stringValue] = value
        }
        return dict
    }

    static func encode(to container: inout UnkeyedEncodingContainer, array: [Any]) throws {
        for value in array {
            if let value = value as? Bool {
                try container.encode(value)
            } else if let value = value as? Int64 {
                try container.encode(value)
            } else if let value = value as? Double {
                try container.encode(value)
            } else if let value = value as? String {
                try container.encode(value)
            } else if value is JSONNull2 {
                try container.encodeNil()
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer()
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }

    static func encode(to container: inout KeyedEncodingContainer<JSONCodingKey>, dictionary: [String: Any]) throws {
        for (key, value) in dictionary {
            let key = JSONCodingKey(stringValue: key)!
            if let value = value as? Bool {
                try container.encode(value, forKey: key)
            } else if let value = value as? Int64 {
                try container.encode(value, forKey: key)
            } else if let value = value as? Double {
                try container.encode(value, forKey: key)
            } else if let value = value as? String {
                try container.encode(value, forKey: key)
            } else if value is JSONNull2 {
                try container.encodeNil(forKey: key)
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer(forKey: key)
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }

    static func encode(to container: inout SingleValueEncodingContainer, value: Any) throws {
        if let value = value as? Bool {
            try container.encode(value)
        } else if let value = value as? Int64 {
            try container.encode(value)
        } else if let value = value as? Double {
            try container.encode(value)
        } else if let value = value as? String {
            try container.encode(value)
        } else if value is JSONNull2 {
            try container.encodeNil()
        } else {
            throw encodingError(forValue: value, codingPath: container.codingPath)
        }
    }

    public required init(from decoder: Decoder) throws {
        if var arrayContainer = try? decoder.unkeyedContainer() {
            self.value = try JSONAny.decodeArray(from: &arrayContainer)
        } else if var container = try? decoder.container(keyedBy: JSONCodingKey.self) {
            self.value = try JSONAny.decodeDictionary(from: &container)
        } else {
            let container = try decoder.singleValueContainer()
            self.value = try JSONAny.decode(from: container)
        }
    }

    public func encode(to encoder: Encoder) throws {
        if let arr = self.value as? [Any] {
            var container = encoder.unkeyedContainer()
            try JSONAny.encode(to: &container, array: arr)
        } else if let dict = self.value as? [String: Any] {
            var container = encoder.container(keyedBy: JSONCodingKey.self)
            try JSONAny.encode(to: &container, dictionary: dict)
        } else {
            var container = encoder.singleValueContainer()
            try JSONAny.encode(to: &container, value: self.value)
        }
    }
}
