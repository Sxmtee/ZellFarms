//
//  AddLocation.swift
//  ZellFarms
//
//  Created by mac on 27/06/2025.
//

import SwiftUI

struct AddLocation: View {
    @Environment(Router.self) private var router
    @State private var cartRepo = CartRepo()
    
    @State private var streetNo: String = ""
    @State private var zipCode: String = ""
    @State private var nearestLandmark: String = ""
    @State private var address: String = ""
    @State private var city: String = ""
    @State private var selectedCountry: String?
    @State private var selectedState: String?
    
    @State private var showValidationError: Bool = false
    @State private var validationErrorMessage: String = ""
    
    // Success state for address creation
    @State private var showAddressSuccess: Bool = false
    @State private var addressSuccessMessage: String = ""
    
    private func validateAndSave() {
        if streetNo.isEmpty || zipCode.isEmpty || nearestLandmark.isEmpty || address.isEmpty || city.isEmpty || selectedCountry == nil || selectedState == nil {
            validationErrorMessage = "Please fill all required fields"
            showValidationError = true
            return
        }
        
        showValidationError = false
        
        Task {
            await cartRepo.createAddress(
                countryId: selectedCountry!,
                stateId: selectedState!,
                streetNo: streetNo,
                landmark: nearestLandmark,
                address: address,
                city: city,
                zipCode: zipCode
            )
            
            if cartRepo.error == nil, let message = cartRepo.successMessage {
                await MainActor.run {
                    addressSuccessMessage = message
                    showAddressSuccess = true
                }
            }
        }
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 15) {
                HStack(spacing: 15) {
                    TextAreas(
                        text: $streetNo,
                        title: "Street No",
                        hintText: "e.g 04",
                        borderColor: showValidationError && streetNo.isEmpty ? .red : .accentColor,
                        icon: "number"
                    )
                    TextAreas(
                        text: $zipCode,
                        title: "Zip Code",
                        hintText: "e.g 400241",
                        borderColor: showValidationError && zipCode.isEmpty ? .red : .accentColor,
                        icon: "number"
                    )
                }
                
                TextAreas(
                    text: $nearestLandmark,
                    title: "Nearest Landmark",
                    hintText: "e.g Living faith church",
                    borderColor: showValidationError && nearestLandmark.isEmpty ? .red : .accentColor,
                    icon: "mappin"
                )
                
                TextAreas(
                    text: $address,
                    title: "Address",
                    hintText: "e.g Adebisi Omotola lane",
                    borderColor: showValidationError && address.isEmpty ? .red : .accentColor,
                    icon: "house"
                )
                
                TextAreas(
                    text: $city,
                    title: "City",
                    hintText: "e.g Ikeja",
                    borderColor: showValidationError && city.isEmpty ? .red : .accentColor,
                    icon: "building.2"
                )
                
                Text("State")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.primary)
                
                if cartRepo.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                } else {
                    Picker("Select your state", selection: $selectedState) {
                        Text("Select your state")
                            .tag(String?.none)
                        ForEach(cartRepo.states) { state in
                            Text(state.name)
                                .tag(state.id)
                        }
                    }
                    .pickerStyle(.menu)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(showValidationError && selectedState == nil ? .red : .gray.opacity(0.2), lineWidth: 1)
                    )
                    .padding(.vertical, 5)
                }
                
                Text("Country")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.primary)
                
                if cartRepo.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                } else {
                    Picker("Select your country", selection: $selectedCountry) {
                        Text("Select your country")
                            .tag(String?.none)
                        ForEach(cartRepo.countries) { country in
                            Text(country.name)
                                .tag(country.id)
                        }
                    }
                    .pickerStyle(.menu)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(showValidationError && selectedCountry == nil ? .red : .gray.opacity(0.2), lineWidth: 1)
                    )
                    .padding(.vertical, 5)
                }
                
                // Validation Error
                if showValidationError {
                    Text(validationErrorMessage)
                        .foregroundColor(.red)
                        .font(.system(size: 14))
                        .padding(.vertical, 5)
                }
                
                CustomButton(
                    action: {
                        validateAndSave()
                    },
                    width: .infinity,
                    text: "Save"
                )
                .padding(.top, 20)
            }
            .padding(.horizontal, 15)
            .padding(.top, 10)
        }
        .navigationTitle("Add a location")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await cartRepo.getCountries()
            await cartRepo.getState()
        }
        .alert(isPresented: $cartRepo.showErrorSnackbar) {
            Alert(
                title: Text("Error"),
                message: Text(cartRepo.error ?? "An error occurred"),
                dismissButton: .default(Text("OK"))
            )
        }
        .alert(isPresented: $showAddressSuccess) {
            Alert(
                title: Text("Success"),
                message: Text(addressSuccessMessage),
                dismissButton: .default(Text("OK")) {
                router.pop()
            })
        }
    }
}
