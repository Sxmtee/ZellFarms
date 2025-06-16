//
//  Register.swift
//  ZellFarms
//
//  Created by mac on 23/05/2025.
//

import SwiftUI

struct Register: View {
    @Environment(Router.self) private var router
    @State private var authRepo = AuthRepo(router: Router())
    @State private var confirmPassword = ""
    @State private var isTermsAccepted = false
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                TextAreas(
                    text: $authRepo.name,
                    title: "Full Name",
                    hintText: "Please enter your full name",
                    borderColor: .accent,
                    icon: "person"
                )
                .textInputAutocapitalization(.never)
                .padding(.bottom, 10)
                
                TextAreas(
                    text: $authRepo.email,
                    title: "Email Address",
                    hintText: "Please enter your email address",
                    borderColor: .accent,
                    icon: "mail"
                )
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.never)
                .padding(.bottom, 10)
                
                TextAreas(
                    text: $authRepo.phoneNumber,
                    title: "Phone Number",
                    hintText: "Please enter your phone number",
                    borderColor: .accent,
                    icon: "phone"
                )
                .keyboardType(.phonePad)
                .padding(.bottom, 10)
                
                TextAreas(
                    text: $authRepo.password,
                    title: "Password",
                    hintText: "Please enter your password",
                    borderColor: .accent,
                    icon: "lock.fill",
                    isSecureField: true
                )
                .padding(.bottom, 10)
                
                TextAreas(
                    text: $confirmPassword,
                    title: "Confirm Password",
                    hintText: "Please confirm your password",
                    borderColor: .accent,
                    icon: "lock.fill",
                    isSecureField: true
                )
                .padding(.bottom, 15)
                
                HStack {
                    Button {
                        isTermsAccepted.toggle()
                    } label: {
                        Image(systemName: isTermsAccepted ? "checkmark.square.fill" : "square")
                            .foregroundColor(isTermsAccepted ? .accent : .gray)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Link(
                        "I agree to the Terms and Conditions",
                        destination: URL(
                            string: "https://zelfarms.com/privacy")!)
                        .foregroundColor(.accent)
                        .font(.system(size: 14))
                    
                    Spacer()
                }
                .padding(.bottom, 15)
                
                CustomButton(
                    action: {
                        Task {
                            await authRepo.register()
                        }
                    },
                    width: .infinity,
                    text: "Register"
                )
                .disabled(!formIsValid)
                .opacity(formIsValid ? 1.0 : 0.5)
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
    }
}


extension Register: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return authRepo.isEmailValid && authRepo.isPasswordValid && authRepo.isPhoneNumberValid && isTermsAccepted && authRepo.password == confirmPassword
    }
}
