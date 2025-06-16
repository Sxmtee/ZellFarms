//
//  Login.swift
//  ZellFarms
//
//  Created by mac on 23/05/2025.
//

import SwiftUI

struct Login: View {
    @Environment(Router.self) private var router
    @State private var authRepo = AuthRepo(router: Router())
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
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
                    text: $authRepo.password,
                    title: "Password",
                    hintText: "Please enter your password",
                    borderColor: .accent,
                    icon: "lock.fill",
                    isSecureField: true
                )
                .padding(.bottom, 15)
                
                Button {
                    router.push(.passwordResetRequest)
                } label: {
                    Text("Forgot password ?")
                        .foregroundStyle(.accent)
                        .font(.system(size: 20, weight: .medium))
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(.bottom, 15)
                }
                
                CustomButton(
                    action: {
                        Task {
                            await authRepo.login()
                        }
                    },
                    width: .infinity,
                    text: "Login"
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

extension Login: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return authRepo.isEmailValid && authRepo.isPasswordValid
    }
}
