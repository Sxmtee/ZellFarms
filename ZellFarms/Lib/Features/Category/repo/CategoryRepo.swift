//
//  CategoryRepo.swift
//  ZellFarms
//
//  Created by mac on 19/03/2025.
//

import Foundation
import SwiftyNetworking


@Observable
class CategoryRepo {
    var showErrorSnackbar = false
    var showSuccessSnackbar = false
    var isLoading = false
    
    var error: String? {
        didSet {
            if error != nil {
                showErrorSnackbar = true
            }
        }
    }
    var successMessage: String? {
        didSet {
            if successMessage != nil {
                showSuccessSnackbar = true
                showErrorSnackbar = false
            }
        }
    }
    
    func getCategories() async throws -> [Categories] {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let request = try SwiftyNetworkingRequest(
                url: URL(string: "\(baseUrl)/products/categories"),
                method: .get
            )
            
            let (data, _) = try await ServiceCall.performRequest(request)
            
            let decoder = JSONDecoder()
            let categoryResponse = try decoder.decode(CategoryModel.self, from: data)
            
            successMessage = categoryResponse.message.isEmpty ? "Categories loaded successfully" : categoryResponse.message
            
            return categoryResponse.data
        } catch {
            self.error = "An unexpected error occurred: \(error.localizedDescription)"
            throw error
        }
    }
}
