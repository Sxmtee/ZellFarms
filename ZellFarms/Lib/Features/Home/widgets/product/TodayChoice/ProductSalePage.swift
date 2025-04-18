//
//  ProductSalePage.swift
//  ZellFarms
//
//  Created by mac on 17/04/2025.
//

import SwiftUI

struct ProductSalePage: View {
    let cheapest: ProductCheapest
    
    @Environment(\.dismiss) var dismiss
    
    @State private var selectedProductUnit: ProductProductUnit
    @State private var totalQuantity: Int = 1
    @State private var currentImageIndex: Int = 0
    private let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    
    init(cheapest: ProductCheapest) {
        self.cheapest = cheapest
        _selectedProductUnit = State(initialValue: cheapest.productUnits.first!)
    }
    
    private func getUnitPriceLabel() -> String {
        return "Unit Price/ \(selectedProductUnit.unit.symbol)"
    }
    
    private func getUnitDisplayText(_ productUnit: ProductProductUnit) -> String {
        return "\(productUnit.unitNumber) \(productUnit.unit.symbol)"
    }
    
    var body: some View {
        ZStack {
            ScrollView {
                // Image Carousel
                TabView(selection: $currentImageIndex) {
                    ForEach(cheapest.images.indices, id: \.self) { index in
                        AsyncImage(
                            url: URL(string: cheapest.images[index].url)
                        ) { image in
                            image
                                .resizable()
                                .scaledToFill()
                        } placeholder: {
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 300)
                                .foregroundStyle(.gray)
                        }
                        .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle())
                .frame(height: 300)
                .padding(.bottom, 10)
                .onReceive(timer) { _ in
                    withAnimation {
                        currentImageIndex = (currentImageIndex + 1) % max(cheapest.images.count, 1)
                    }
                }
                
                VStack(alignment: .leading) {
                    HStack {
                        Text(cheapest.name)
                            .font(.system(size: 20, weight: .bold))
                        
                        Spacer()
                        
                        Button {
                            // TODO: Implement cart logic
                        } label: {
                            Image(systemName: "cart.fill")
                                .foregroundStyle(.accent)
                                .font(.title2)
                        }
                    }
                    .padding(.bottom, 5)
                    
                    Text(getUnitPriceLabel())
                        .foregroundStyle(Color(uiColor: .systemGray))
                        .padding(.bottom, 6)
                    
                    HStack {
                        Text(formatPrice(String(selectedProductUnit.pricePerUnit)))
                            .foregroundStyle(.accent)
                            .font(.system(size: 18, weight: .medium))
                        
                        Spacer()
                        
                        Picker("Select Unit", selection: $selectedProductUnit) {
                            ForEach(cheapest.productUnits, id: \.id) { productUnit in
                                Text(getUnitDisplayText(productUnit))
                                    .tag(productUnit)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                    }
                    .padding(.bottom, 6)
                    
                    DetailAd()
                        .padding(.bottom, 6)
                    
                    Text("Description")
                        .font(.system(size: 20, weight: .bold))
                        .padding(.bottom, 5)
                    
                    Text(cheapest.description)
                        .multilineTextAlignment(.leading)
                }
                .padding()
            }
            .safeAreaInset(edge: .bottom) { 
                ProductBottomBar(
                    selectedProductUnit: $selectedProductUnit,
                    totalQuantity: $totalQuantity,
                    cheapest: cheapest
                )
            }
        }
        .ignoresSafeArea()
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button{
                    dismiss()
                } label: {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text(cheapest.name)
                            .font(.system(size: 20, weight:.bold))
                    }
                    .foregroundColor(.white)
                }
            }
        }
    }
}
