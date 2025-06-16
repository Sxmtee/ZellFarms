//
//  VerificationScreen.swift
//  ZellFarms
//
//  Created by mac on 24/05/2025.
//

import SwiftUI

struct VerificationScreen: View {
    let email: String
    
    @Environment(Router.self) private var router
    @State private var authRepo = AuthRepo(router: Router())
    @State private var otpDigits: [String] = Array(repeating: "", count: 5)
    @State private var focusedField: Int? = 0
    @FocusState private var focusedFieldIndex: Int?
    
    var combinedOTP: String {
        otpDigits.joined()
    }
    
    var body: some View {
        VStack {
            Text("Enter the 5-digit Verification OTP sent to \(email)")
                .multilineTextAlignment(.center)
                .font(.system(size:20, weight: .semibold))
                .padding(.bottom, 10)
            
            HStack(spacing: 10) {
                ForEach(0..<5) { index in
                    TextField("", text: $otpDigits[index])
                        .frame(width: 50, height: 50)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .strokeBorder(Color.accentColor, lineWidth: 1)
                        )
                        .multilineTextAlignment(.center)
                        .textInputAutocapitalization(.characters)
                        .focused($focusedFieldIndex, equals: index)
                        .onChange(of: otpDigits[index]) {_, newValue in
                            // Move to next field when a digit is entered
                            if newValue.count == 1 && index < 4 {
                                focusedFieldIndex = index + 1
                            }
                            // Move back if digit is deleted
                            else if newValue.isEmpty && index > 0 {
                                focusedFieldIndex = index - 1
                            }
                            // Limit to single character
                            if newValue.count > 1 {
                                otpDigits[index] = String(newValue.prefix(1))
                            }
                        }
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 10)
            
            CustomButton(
                action: {
                    Task {
                        await authRepo.verificationOTP(
                            emails: email,
                            otp: combinedOTP
                        )
                    }
                },
                text: "Verify OTP"
            )
            .disabled(combinedOTP.count != 5)
            .padding(.bottom, 10)
            
            HStack {
                Text("Didn't recieve OTP?")
                
                Button {
                    Task {
                        await authRepo.resendOTP(emails: email)
                    }
                } label: {
                    Text("Resend OTP")
                        .fontWeight(.semibold)
                        .foregroundStyle(.accent)
                }
            }
        }
        .padding(15)
        .navigationTitle("Verification OTP")
        .onAppear {
            authRepo.router = router
        }
    }
}
