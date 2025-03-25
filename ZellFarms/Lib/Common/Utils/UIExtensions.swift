//
//  UIExtensions.swift
//  ZellFarms
//
//  Created by mac on 19/03/2025.
//

import Foundation

let baseUrl = "https://admin.zelfarms.com/api/v1"

func formatPrice(_ price: String) -> String {
    // Remove the currency symbol if present
    let cleanedPrice = price.replacingOccurrences(of: "₦", with: "")
    
    // Parse the price as a Double
    guard let parsedPrice = Double(cleanedPrice) else {
        return price // Return original string if parsing fails
    }
    
    // Create a NumberFormatter for Nigerian Naira
    let formatter = NumberFormatter()
    formatter.locale = Locale(identifier: "en_NG") // Nigerian locale
    formatter.numberStyle = .currency
    formatter.currencySymbol = "₦"
    formatter.minimumFractionDigits = 2
    formatter.maximumFractionDigits = 2
    
    // Format the price
    return formatter.string(from: NSNumber(value: parsedPrice)) ?? "\(parsedPrice)"
}

func getUnitDisplayText(_ unit: ProductUnit) -> String {
    return "\(unit.unitNumber) \(unit.unit.name)"
}
