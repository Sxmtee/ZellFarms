//
//  PasswordResetRequest.swift
//  ZellFarms
//
//  Created by mac on 24/05/2025.
//

import SwiftUI

struct PasswordResetRequest: View {
    @Environment(Router.self) private var router
    @State private var authRepo = AuthRepo(router: Router())
    @State private var email = ""
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading) {
                Text("Enter your registered email address to reset your password")
                    .font(.system(size: 20, weight: .none))
                    .padding(.bottom, 10)
                
                TextAreas(
                    text: $email,
                    title: "",
                    hintText: "Email Address",
                    icon: "mail"
                )
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.never)
                .padding(.bottom, 20)
                
                CustomButton(
                    action: {
                        Task {
                            await authRepo.passwordResetRequest(emails: email)
                        }
                    },
                    width: .infinity,
                    text: "Request Password Reset"
                )
            }
        }
        .navigationTitle("Password Reset Request")
        .scrollBounceBehavior(.basedOnSize)
        .padding(15)
        .onAppear {
            authRepo.router = router
        }
    }
}
