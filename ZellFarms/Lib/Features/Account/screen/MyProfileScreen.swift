//
//  MyProfileScreen.swift
//  ZellFarms
//
//  Created by mac on 28/05/2025.
//

import SwiftUI

struct MyProfileScreen: View {
    @Environment(Router.self) private var router
    @State private var authRepo = AuthRepo(router: Router())
    @State private var name = ""
    @State private var email = ""
    @State private var phone = ""
    @State private var selectedGender = "Male"
    @State private var dob = Date()
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    let genderOptions = ["Male", "Female"]
    
    private func fetchUserData() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let json = try await authRepo.getUserData()
            if let dataDict = json["data"] as? [String: Any] {
                await MainActor.run {
                    name = dataDict["name"] as? String ?? ""
                    email = dataDict["email"] as? String ?? ""
                    phone = dataDict["phone"] as? String ?? ""
                    if let gender = dataDict["gender"] as? String, genderOptions.contains(gender.capitalized) {
                        selectedGender = gender.capitalized
                    }
                    if let dobString = dataDict["dob"] as? String {
                        let formatter = DateFormatter()
                        formatter.dateFormat = "yyyy-MM-dd"
                        if let date = formatter.date(from: dobString) {
                            dob = date
                        }
                    }
                }
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    private func saveProfile() {
        // Format date of birth
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dobString = formatter.string(from: dob)
        
        Task {
            await authRepo.updateUserData(
                names: name,
                emails: email,
                phone: phone,
                gender: selectedGender.lowercased(),
                dateOfBirth: dobString
            )
        }
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                Image("meme")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .padding(.bottom, 15)
                
                Picker("Gender", selection: $selectedGender) {
                    ForEach(genderOptions, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(.segmented)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(.systemGray6))
                )
                .padding(.bottom, 15)
                
                TextAreas(
                    text: $name,
                    title: "",
                    hintText: "enter your name",
                    icon: "person.fill"
                )
                .padding(.bottom, 15)
                
                TextAreas(
                    text: $email,
                    title: "",
                    hintText: "enter your mail",
                    icon: "mail"
                )
                .padding(.bottom, 15)
                
                TextAreas(
                    text: $phone,
                    title: "",
                    hintText: "enter your number",
                    icon: "phone"
                )
                .keyboardType(.numberPad)
                .padding(.bottom, 15)
                
                DatePicker(
                    "Date of Birth",
                    selection: $dob,
                    in: ...Date(),
                    displayedComponents: [.date]
                )
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(.systemGray6))
                )
                .padding(.bottom, 15)
                
                CustomButton(
                    action: { saveProfile() },
                    width: .infinity,
                    text: "Save"
                )
            }
            .padding(15)
        }
        .navigationTitle("My Profile")
        .overlay {
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black.opacity(0.3))
            }
        }
        .snackbar(
            isShowing: $authRepo.showErrorSnackbar,
            message: authRepo.error ?? ""
        )
        .snackbar(
            isShowing: $authRepo.showSuccessSnackbar,
            message: authRepo.successMessage ?? "",
            isSuccess: true
        )
        .onAppear {
            authRepo.router = router
        }
        .task {
            await fetchUserData()
        }
    }
}
