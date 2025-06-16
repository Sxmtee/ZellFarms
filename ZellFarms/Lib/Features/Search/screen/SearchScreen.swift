//
//  SearchScreen.swift
//  ZellFarms
//
//  Created by mac on 28/04/2025.
//

import SwiftUI
import Combine

struct SearchScreen: View {
    @State private var controller = CategoryRepo()
    @State private var searchText = ""
    @State private var cancellable: AnyCancellable?
    
    private func debounceSearch(query: String) {
        cancellable?.cancel()
        cancellable = Just(query)
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .sink { debouncedQuery in
                print("Debounced query: \(debouncedQuery)")
                Task {
                    await controller.searchProducts(
                        category: "",
                        search: debouncedQuery
                    )
                    print("Search completed for: \(debouncedQuery), results: \(controller.searches.count)")
                }
            }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                TextField(
                    "Search for products, categories, etc...",
                    text: $searchText
                )
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .onChange(of: searchText) {oldValue, newValue in
                        debounceSearch(query: newValue)
                    }
                
                Button {
                    Task {
                        await controller.searchProducts(
                            category: "",
                            search: searchText
                        )
                    }
                } label: {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.accentColor)
                        .clipShape(Circle())
                }
            }
            
            if searchText.isEmpty {
                VStack {
                    Spacer()
                    Text("Search for something")
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .center)
                    Spacer()
                }
            } else if !controller.searches.isEmpty {
                ScrollView(showsIndicators: false) {
                    ForEach(controller.searches, id: \.id) { item in
                        SearchCard(searchData: item)
                    }
                }
            } else {
                VStack {
                    Spacer()
                    Text("No results found")
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .center)
                    Spacer()
                }
            }
            
            Spacer()
        }
        .padding()
        .padding(.bottom, 60)
    }
}
