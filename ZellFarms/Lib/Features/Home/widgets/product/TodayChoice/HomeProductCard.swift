//
//  HomeProductCard.swift
//  ZellFarms
//
//  Created by mac on 17/04/2025.
//

import SwiftUI

struct HomeProductCard: View {
    let picture: String
    let productName: String
    let unitPrice: String
    var onTap: (()->())?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            AsyncImage(url: URL(string: picture)) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(height: 100)
                        .clipped()
                case .failure:
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 100)
                        .foregroundStyle(.gray)
                case .empty:
                    ProgressView()
                        .frame(height: 100)
                @unknown default:
                    EmptyView()
                }
            }
            .frame(maxWidth: .infinity)
            .background(Color.gray.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            

            Text(productName)
                .font(.system(size: 16, weight: .bold))
                .lineLimit(2)
                .minimumScaleFactor(0.8)
            

            Text(unitPrice)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(.secondary)
                .lineLimit(1)
        }
        .padding(12)
        .frame(width: 160)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(Color.primary.opacity(0.2), lineWidth: 1)
        )
        .onTapGesture {
            onTap?()
        }
    }
}
