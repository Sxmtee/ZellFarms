//
//  ResetPassword.swift
//  ZellFarms
//
//  Created by mac on 24/05/2025.
//

import SwiftUI

struct ResetPassword: View {
    let email: String
    let otp: String
    
    @Environment(Router.self) private var router
    @State private var authRepo = AuthRepo(router: Router())
    @State private var password = ""
    @State private var confirmPassword = ""
    
    private var isFormValid: Bool {
        !password.isEmpty && password == confirmPassword
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading) {
                TextAreas(
                    text: $password,
                    title: "Password",
                    hintText: "enter your new password",
                    icon: "lock.fill",
                    isSecureField: true
                )
                .textInputAutocapitalization(.never)
                .padding(.bottom, 10)
                
                TextAreas(
                    text: $confirmPassword,
                    title: "Confirm Password",
                    hintText: "confirm your new password",
                    icon: "lock.fill",
                    isSecureField: true
                )
                .textInputAutocapitalization(.never)
                .padding(.bottom, 10)
                
                CustomButton(
                    action: {
                        Task {
                            await authRepo.resetPassword(
                                emails: email,
                                resetToken: otp,
                                newPassword: password,
                                rePassword: confirmPassword
                            )
                        }
                    },
                    width: .infinity,
                    text: "Reset Password"
                )
                .disabled(!isFormValid)
            }
        }
        .navigationTitle("Reset Password")
        .scrollBounceBehavior(.basedOnSize)
        .padding(15)
        .onAppear {
            authRepo.router = router
        }
    }
}
