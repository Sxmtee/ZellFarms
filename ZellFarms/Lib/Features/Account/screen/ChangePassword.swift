//
//  ChangePassword.swift
//  ZellFarms
//
//  Created by mac on 26/05/2025.
//

import SwiftUI

struct ChangePassword: View {
    @Environment(Router.self) private var router
    @State private var authRepo = AuthRepo(router: Router())
    @State private var newPassword = ""
    @State private var confirmNewPassword = ""
    
    private var isFormValid: Bool {
        !newPassword.isEmpty && newPassword == confirmNewPassword
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading) {
                TextAreas(
                    text: $authRepo.password,
                    title: "Old Password",
                    hintText: "enter old password",
                    icon: "lock.fill"
                )
                .textInputAutocapitalization(.never)
                .padding(.bottom, 10)
                
                TextAreas(
                    text: $newPassword,
                    title: "New Password",
                    hintText: "enter new password",
                    icon: "lock.fill",
                    isSecureField: true
                )
                .textInputAutocapitalization(.never)
                .padding(.bottom, 10)
                
                TextAreas(
                    text: $confirmNewPassword,
                    title: "Confirm New Password",
                    hintText: "re-enter new password",
                    icon: "lock.fill",
                    isSecureField: true
                )
                .textInputAutocapitalization(.never)
                .padding(.bottom, 10)
                
                CustomButton(
                    action: {
                        Task {
                            await authRepo.changePassword(newPassword: newPassword)
                        }
                    },
                    width: .infinity,
                    text: "Update Password"
                )
                .disabled(!isFormValid)
            }
        }
        .navigationTitle("Change Password")
        .scrollBounceBehavior(.basedOnSize)
        .padding(15)
        .onAppear {
            authRepo.router = router
        }
    }
}
