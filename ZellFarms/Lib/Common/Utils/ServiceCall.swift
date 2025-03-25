//
//  ServiceCall.swift
//  ZellFarms
//
//  Created by mac on 19/03/2025.
//

import Foundation
import SwiftyNetworking

enum NetworkError: Error {
    case invalidURL
    case invalidParameters
    case noData
    case decodingError
    case serverError(String)
}

@MainActor
class ServiceCall {
    static func performRequest(_ request: SwiftyNetworkingRequest) async throws -> (data: Data, statusCode: Int) {
        var urlRequest = URLRequest(url: request.url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.allHTTPHeaderFields = request.headers
        urlRequest.httpBody = request.body
        urlRequest.timeoutInterval = request.timeout
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        // Print raw response for debugging
//        if let rawString = String(data: data, encoding: .utf8) {
//            print("Raw Response Data: \(rawString)")
//        } else {
//            print("Raw Response Data: Unable to convert to string")
//        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.serverError("Invalid response type")
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.serverError("Server returned status code: \(httpResponse.statusCode)")
        }
        
        return (data: data, statusCode: httpResponse.statusCode)
    }
}
