//
//  SearchCard.swift
//  ZellFarms
//
//  Created by mac on 28/04/2025.
//

import SwiftUI

struct SearchCard: View {
    let searchData: SearchData
    
    @Environment(Router.self) private var router
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            AsyncImage(
                url: URL(string: searchData.images.first?.url ?? "")
            ) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(height: 120)
                        .clipped()
                case .failure:
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 120)
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
            

            Text(searchData.name)
                .font(.system(size: 16, weight: .bold))
                .lineLimit(2)
                .minimumScaleFactor(0.8)
            

            Text(formatPrice(String(searchData.productUnits[0].pricePerUnit)))
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(.secondary)
                .lineLimit(1)
        }
        .padding(12)
        .frame(width: .infinity, height: 200)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(Color.primary.opacity(0.2), lineWidth: 1)
        )
        .onTapGesture {
            router.push(.searchSalePage(searchData: searchData))
        }
        .environment(router)
    }
}
