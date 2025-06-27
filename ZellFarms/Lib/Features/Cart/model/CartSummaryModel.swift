//
//  CartSummaryModel.swift
//  ZellFarms
//
//  Created by mac on 24/06/2025.
//


struct CartSummaryModel: Hashable {
    let id: String
    let name: String
    let price: Int
    var quantity: Int
    let productId: String
    let unitName: String
}


struct PaymentChannel: Identifiable {
    let id: String // Using name as ID
    let name: String
    let description: String
}
