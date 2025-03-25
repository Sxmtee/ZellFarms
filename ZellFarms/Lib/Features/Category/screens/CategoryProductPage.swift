//
//  CategoryProductPage.swift
//  ZellFarms
//
//  Created by mac on 24/03/2025.
//

import SwiftUI

struct CategoryProductPage: View {
    let product: Product
    
    @Environment(\.dismiss) var dismiss
    @State private var selectedProductUnit: ProductUnit
    @State private var totalQuantity: Int = 1
    
    init(product: Product) {
        self.product = product
        _selectedProductUnit = State(initialValue: product.productUnits.first!)
    }
    
    private func getUnitPriceLabel() -> String {
        return "Unit Price/per \(selectedProductUnit.unit.symbol)"
    }
    
    var body: some View {
        ZStack {
            ScrollView {
                Image(.cat)
                    .resizable()
                    .scaledToFit()
                    .padding(.bottom, 10)
                
                VStack(alignment: .leading) {
                    HStack {
                        Text(product.name)
                            .font(.system(size: 20, weight: .bold))
                        
                        Spacer()
                        
                        Button {
                            //code to come
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
                            ForEach(product.productUnits, id:\.id) { productunit in
                                Text(getUnitDisplayText(productunit))
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
                    
                    Text(product.description)
                        .multilineTextAlignment(.leading)
                }
                .padding()
            }
            .safeAreaInset(edge: .bottom) {
                BottomNavigationBar(
                    selectedProductUnit: $selectedProductUnit,
                    totalQuantity: $totalQuantity,
                    product: product
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
                        Text(product.name)
                            .font(.system(size: 20, weight:.bold))
                    }
                    .foregroundColor(.white)
                }
            }
        }
        .onChange(of: selectedProductUnit) { oldValue, newValue in
            selectedProductUnit = newValue
            totalQuantity = 1
        }
    }
}
