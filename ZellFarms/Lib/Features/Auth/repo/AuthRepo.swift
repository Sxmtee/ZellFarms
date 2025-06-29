//
//  AuthRepo.swift
//  ZellFarms
//
//  Created by mac on 16/05/2025.
//

import Foundation
import SwiftyNetworking

protocol AuthenticationFormProtocol {
    var formIsValid: Bool { get }
}

@Observable
class AuthRepo {
    var name = "" {
        didSet { validateName() }
    }
    var email = "" {
        didSet { validateEmail() }
    }
    var password = "" {
        didSet { validatePassword() }
    }
    var phoneNumber = "" {
        didSet { validateNumber() }
    }
    var gender = "" {
        didSet { validateGender() }
    }
    var dateOfBirth = "" {
        didSet { validateDateOfBirth() }
    }
    
    var showErrorSnackbar = false
    var showSuccessSnackbar = false
    var isLoading = false
    
    var error: String? {
        didSet {
            if error != nil {
                showErrorSnackbar = true
            }
        }
    }
    var successMessage: String? {
        didSet {
            if successMessage != nil {
                showSuccessSnackbar = true
                showErrorSnackbar = false
            }
        }
    }
    
    private func clearFields() {
        name = ""
        email = ""
        password = ""
        phoneNumber = ""
    }
        
    // Validation states
    var isNameValid = false
    var isEmailValid = false
    var isPasswordValid = false
    var isPhoneNumberValid = false
    var isGenderValid = false
    var isDateOfBirthValid = false
    
    private func validateName() {
        isNameValid = name.count >= 3
    }
    
    private func validateEmail() {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        isEmailValid = emailPredicate.evaluate(with: email)
    }
    
    private func validatePassword() {
        isPasswordValid = password.count >= 8
    }
    
    private func validateNumber() {
        isPhoneNumberValid = phoneNumber.count == 11
    }
    
    private func validateGender() {
        isGenderValid = ["male", "female"].contains(gender.lowercased())
    }
    
    private func validateDateOfBirth() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        isDateOfBirthValid = !dateOfBirth.isEmpty && formatter.date(from: dateOfBirth) != nil
    }
    
    var router: Router
    private let cartRepo = CartRepo()
    
    init(router: Router) {
        self.router = router
        validateName()
        validateEmail()
        validatePassword()
        validateNumber()
    }
    
    func login () async {
        guard isEmailValid else {
            error = "Please enter a valid email"
            return
        }
        guard isPasswordValid else {
            error = "Please enter a Password with more than 7 characters"
            return
        }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            let body: [String: Any] = [
                "email": email,
                "password": password,
            ]
            
            let bodyData = try JSONSerialization.data(withJSONObject: body)
            
            let request = try SwiftyNetworkingRequest(
                url: URL(string: "\(baseUrl)/auth/login"),
                method: .post,
                headers: ["Content-Type": "application/json"],
                body: bodyData
            )
            
            let (data, _) = try await ServiceCall.performRequest(request)
            
            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
            
            if let dataDict = json?["data"] as? [String: Any],
               let accessToken = dataDict["access_token"] as? String,
               let userDict = dataDict["user"] as? [String: Any],
               let nickname = userDict["name"] as? String {
                ZelPreferences.email = email
                ZelPreferences.accessToken = accessToken
                ZelPreferences.username = nickname
                
                await cartRepo.syncLocalCartToServer()
                if cartRepo.error == nil {
                    await cartRepo.getCart()
                }
            }
            
            if let message = json?["message"] as? String {
                await MainActor.run {
                    clearFields()
                    self.router.pop()
                    self.successMessage = message
                }
            }
        } catch {
            self.error = "An unexpected error occurred: \(error.localizedDescription)"
        }
    }
    
    func passwordResetRequest(emails: String) async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let body: [String: Any] = ["email": emails]
            
            let bodyData = try JSONSerialization.data(withJSONObject: body)
            
            let request = try SwiftyNetworkingRequest(
                url: URL(string: "\(baseUrl)/password/reset-request"),
                method: .post,
                headers: ["Content-Type": "application/json"],
                body: bodyData
            )
            
            let (data, _) = try await ServiceCall.performRequest(request)
            
            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
            
            if let message = json?["message"] as? String {
                await MainActor.run {
                    self.router.replace(.verifyResetRequest(email: emails))
                    self.successMessage = message
                }
            }
        } catch {
            self.error = "An unexpected error occurred: \(error.localizedDescription)"
        }
    }
    
    func verifyResetRequest(emails: String, otp: String) async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let body: [String: Any] = [
                "email": emails,
                "otp": otp
            ]
            
            let bodyData = try JSONSerialization.data(withJSONObject: body)
            
            let request = try SwiftyNetworkingRequest(
                url: URL(string: "\(baseUrl)/password/verify-request"),
                method: .post,
                headers: ["Content-Type": "application/json"],
                body: bodyData
            )
            
            let (data, _) = try await ServiceCall.performRequest(request)
            
            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
            
            if let dataDict = json?["data"] as? [String: Any],
               let resetToken = dataDict["reset_token"] as? String {
                await MainActor.run {
                    self.router.replace(.resetPassword(
                        email: emails,
                        otp: resetToken)
                    )
                    self.successMessage = "Request Verified"
                }
            }
        } catch {
            self.error = "An unexpected error occurred: \(error.localizedDescription)"
        }
    }
    
    func resetPassword(emails: String, resetToken: String, newPassword: String, rePassword: String) async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let body: [String: Any] = [
                "email": emails,
                "reset_token": resetToken,
                "password": newPassword,
                "password_confirmation": rePassword,
            ]
            
            let bodyData = try JSONSerialization.data(withJSONObject: body)
            
            let request = try SwiftyNetworkingRequest(
                url: URL(string: "\(baseUrl)/password/reset"),
                method: .patch,
                headers: [
                    "Content-Type": "application/json",
                    "Authorization": "Bearer \(resetToken)"
                ],
                body: bodyData
            )
            
            let (data, _) = try await ServiceCall.performRequest(request)
            
            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
            
            if let message = json?["message"] as? String {
                await MainActor.run {
                    self.router.pop()
                    self.successMessage = message
                }
            }
        } catch {
            self.error = "An unexpected error occurred: \(error.localizedDescription)"
        }
    }
    
    func register () async {
        guard isEmailValid else {
            error = "Please enter a valid email"
            return
        }
        guard isNameValid else {
            error = "Please enter a valid name"
            return
        }
        guard isPasswordValid else {
            error = "Please enter a Password with more than 7 characters"
            return
        }
        guard isPhoneNumberValid else {
            error = "Please enter a valid phone number"
            return
        }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            let body: [String: Any] = [
                "name": name,
                "email": email,
                "phone": phoneNumber,
                "password": password,
                "password_confirmation": password,
            ]
            
            let bodyData = try JSONSerialization.data(withJSONObject: body)
            
            let request = try SwiftyNetworkingRequest(
                url: URL(string: "\(baseUrl)/auth/register"),
                method: .post,
                headers: ["Content-Type": "application/json"],
                body: bodyData
            )
            
            let (data, _) = try await ServiceCall.performRequest(request)
            
            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
            
            if let message = json?["message"] as? String {
                await MainActor.run {
                    self.successMessage = message
                    self.router.replace(.verificationOtp(email: email))
                }
            }
        } catch {
            self.error = "An unexpected error occurred: \(error.localizedDescription)"
        }
    }
    
    func verificationOTP(emails: String, otp: String) async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let body: [String: Any] = [
                "email": emails,
                "type": "account_activation",
                "otp": otp,
            ]
            
            let bodyData = try JSONSerialization.data(withJSONObject: body)
            
            let request = try SwiftyNetworkingRequest(
                url: URL(string: "\(baseUrl)/auth/verify"),
                method: .post,
                headers: ["Content-Type": "application/json"],
                body: bodyData
            )
            
            let (data, _) = try await ServiceCall.performRequest(request)
            
            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
            
            if let dataDict = json?["data"] as? [String: Any],
               let accessToken = dataDict["access_token"] as? String,
               let userDict = dataDict["user"] as? [String: Any],
               let nickname = userDict["name"] as? String {
                ZelPreferences.email = email
                ZelPreferences.accessToken = accessToken
                ZelPreferences.username = nickname
                
                await cartRepo.syncLocalCartToServer()
                if cartRepo.error == nil {
                    await cartRepo.getCart()
                }
            }
            
            if let message = json?["message"] as? String {
                await MainActor.run {
                    clearFields()
                    self.router.pop()
                    self.successMessage = message
                }
            }
        } catch {
            self.error = "An unexpected error occurred: \(error.localizedDescription)"
        }
    }
    
    func resendOTP(emails: String) async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let body: [String: Any] = [
                "email": emails,
                "type": "account_activation",
            ]
            
            let bodyData = try JSONSerialization.data(withJSONObject: body)
            
            let request = try SwiftyNetworkingRequest(
                url: URL(string: "\(baseUrl)/auth/resend-otp"),
                method: .post,
                headers: ["Content-Type": "application/json"],
                body: bodyData
            )
            
            let (data, _) = try await ServiceCall.performRequest(request)
            
            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
            
            if let message = json?["message"] as? String {
                await MainActor.run {
                    self.successMessage = message
                }
            }
        } catch {
            self.error = "An unexpected error occurred: \(error.localizedDescription)"
        }
    }
    
    func changePassword(newPassword: String) async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let body: [String: Any] = [
                "old_password": password,
                "password": newPassword,
                "password_confirmation": newPassword,
            ]
            
            let bodyData = try JSONSerialization.data(withJSONObject: body)
            
            let token = ZelPreferences.accessToken
            
            let request = try SwiftyNetworkingRequest(
                url: URL(string: "\(baseUrl)/auth/update-password"),
                method: .patch,
                headers: [
                    "Content-Type": "application/json",
                    "Authorization": "Bearer \(token)"
                ],
                body: bodyData
            )
            
            let (data, _) = try await ServiceCall.performRequest(request)
            
            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
            
            if let message = json?["message"] as? String {
                await MainActor.run {
                    self.router.pop()
                    self.successMessage = message
                }
            }
        } catch {
            self.error = "An unexpected error occurred: \(error.localizedDescription)"
        }
    }
    
    func initiateDelete() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let token = ZelPreferences.accessToken
            
            let request = try SwiftyNetworkingRequest(
                url: URL(string: "\(baseUrl)/auth/initiate-delete"),
                method: .post,
                headers: [
                    "Content-Type": "application/json",
                    "Authorization": "Bearer \(token)"
                ]
            )
            
            let (data, _) = try await ServiceCall.performRequest(request)
            
            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
            
            if let message = json?["message"] as? String {
                await MainActor.run {
                    self.router.push(.deleteOtpScreen)
                    self.successMessage = message
                }
            }
        } catch {
            self.error = "An unexpected error occurred: \(error.localizedDescription)"
        }
    }
    
    func deleteAccount(otp: String) async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let body: [String: Any] = [ "otp": otp ]
            
            let bodyData = try JSONSerialization.data(withJSONObject: body)
            
            let token = ZelPreferences.accessToken
            
            let request = try SwiftyNetworkingRequest(
                url: URL(string: "\(baseUrl)/auth/delete-account"),
                method: .patch,
                headers: [
                    "Content-Type": "application/json",
                    "Authorization": "Bearer \(token)"
                ],
                body: bodyData
            )
            
            let (data, _) = try await ServiceCall.performRequest(request)
            
            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
            
            if let message = json?["message"] as? String {
                await MainActor.run {
                    self.successMessage = message
                    ZelPreferences.clearAll()
                    self.router.pop()
                }
            }
        } catch {
            self.error = "An unexpected error occurred: \(error.localizedDescription)"
        }
    }
    
    func getUserData() async throws -> [String: Any] {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let token = ZelPreferences.accessToken
            
            let request = try SwiftyNetworkingRequest(
                url: URL(string: "\(baseUrl)/auth/profile"),
                method: .get,
                headers: [ "Authorization": "Bearer \(token)" ]
            )
            
            let (data, _) = try await ServiceCall.performRequest(request)
            
            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
            
            return json!
        } catch {
            self.error = "An unexpected error occurred: \(error.localizedDescription)"
            throw error
        }
    }
    
    func updateUserData(
        names: String,
        emails: String,
        phone: String,
        gender: String,
        dateOfBirth: String
    ) async {
        // Set properties to trigger validation
        self.name = names
        self.email = emails
        self.phoneNumber = phone
        self.gender = gender
        self.dateOfBirth = dateOfBirth
        
        // Validate all inputs
        guard isNameValid else {
            error = "Name must be at least 3 characters"
            return
        }
        guard isEmailValid else {
            error = "Please enter a valid email"
            return
        }
        guard isPhoneNumberValid else {
            error = "Phone number must be 11 digits"
            return
        }
        guard isGenderValid else {
            error = "Please select a valid gender (male or female)"
            return
        }
        guard isDateOfBirthValid else {
            error = "Please enter a valid date of birth (yyyy-MM-dd)"
            return
        }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            let body: [String: Any] = [
                "name": names,
                "email": emails,
                "phone": phone,
                "gender": gender,
                "dob": dateOfBirth,
            ]
            
            let bodyData = try JSONSerialization.data(withJSONObject: body)
            
            let token = ZelPreferences.accessToken
            
            let request = try SwiftyNetworkingRequest(
                url: URL(string: "\(baseUrl)/auth/update-profile"),
                method: .patch,
                headers: [ "Authorization": "Bearer \(token)" ],
                body: bodyData
            )
            
            let (data, _) = try await ServiceCall.performRequest(request)
            
            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
            
            if let message = json?["message"] as? String {
                await MainActor.run {
                    self.router.pop()
                    self.successMessage = message
                }
            }
        } catch {
            self.error = "An unexpected error occurred: \(error.localizedDescription)"
        }
    }
}
