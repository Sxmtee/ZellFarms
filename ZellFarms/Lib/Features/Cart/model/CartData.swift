//
//  CartData.swift
//  ZellFarms
//
//  Created by mac on 16/06/2025.
//


struct CartData: Codable {
    let productId: String
    let productUnits: [CartProductUnits]
    
    enum CodingKeys: String, CodingKey {
        case productId = "product_id"
        case productUnits = "product_units"
    }
}

struct CartProductUnits: Codable {
    let productUnitId: String
    let quantity: Int
    
    enum CodingKeys: String, CodingKey {
        case productUnitId = "product_unit_id"
        case quantity
    }
}


struct LocalCartItem: Codable {
    let productId: String
    let productUnitId: String
    var quantity: Int
    let name: String
    let price: Int
    let unitName: String
}
