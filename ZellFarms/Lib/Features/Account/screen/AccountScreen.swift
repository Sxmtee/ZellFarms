//
//  AccountScreen.swift
//  ZellFarms
//
//  Created by mac on 16/05/2025.
//

import SwiftUI

enum Theme: String, CaseIterable {
    case light = "Light"
    case dark = "Dark"
    case system = "System"
}

struct AccountScreen: View {
    @Environment(Router.self) private var router
    @Environment(\.dismiss) private var dismiss
    @State private var authRepo = AuthRepo(router: Router())
    
    @State private var showThemePicker = false
    @State private var showLogout = false
    @State private var showDelete = false
    
    @State private var name = ZelPreferences.username
    
    private func applyTheme(_ theme: Theme) {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let windows = windowScene?.windows
        
        switch theme {
        case .light:
            windows?.forEach { $0.overrideUserInterfaceStyle = .light }
        case .dark:
            windows?.forEach { $0.overrideUserInterfaceStyle = .dark }
        case .system:
            windows?.forEach { $0.overrideUserInterfaceStyle = .unspecified }
        }
    }
    
    var body: some View {
        List {
            Section("Profile") {
                if !name.isEmpty {
                    ListTile(
                        leadingIcon: "person",
                        title: "My Profile",
                        trailingIcon: "chevron.right",
                        action: {
                            router.push(.profilescreen)
                        }
                    )
                }
                
                ListTile(
                    leadingIcon: "bell.badge",
                    title: "Notifications",
                    trailingIcon: "chevron.right",
                    action: {
                        router.push(.notificationscreen)
                    }
                )
            }
            
            Section("Appearance") {
                ListTile(
                    leadingIcon: "paintpalette",
                    title: "Theme",
                    trailingIcon: nil,
                    action: {
                        showThemePicker = true
                    }
                )
            }
            
            Section("Legal") {
                ListTile(
                    leadingIcon: "doc.text",
                    title: "Privacy Policy",
                    trailingIcon: nil,
                    action: {
                        if let url = URL(string: "https://zelfarms.com/privacy") {
                            UIApplication.shared.open(
                                url,
                                options: [:],
                                completionHandler: nil
                            )
                        }
                    }
                )
                ListTile(
                    leadingIcon: "questionmark.circle",
                    title: "Help Center",
                    trailingIcon: "chevron.right",
                    action: {
                        router.push(.helpcenter)
                    }
                )
            }
            
            
            Section("Account Actions") {
                if !name.isEmpty {
                    ListTile(
                        leadingIcon: "lock",
                        title: "Change Password",
                        trailingIcon: "chevron.right",
                        action: {
                            router.push(.changePassword)
                        }
                    )
                    
                    ListTile(
                        leadingIcon: "rectangle.portrait.and.arrow.forward",
                        title: "Log Out",
                        trailingIcon: nil,
                        textColor: Color.red.opacity(0.6),
                        action: {
                            showLogout = true
                        }
                    )
                    
                    ListTile(
                        leadingIcon: "trash",
                        title: "Delete Account",
                        trailingIcon: nil,
                        textColor: .red,
                        action: {
                            showDelete = true
                        }
                    )
                } else {
                    ListTile(
                        leadingIcon: "rectangle.portrait.and.arrow.right",
                        title: "Login/Register",
                        trailingIcon: nil,
                        textColor: .blue,
                        action: {
                            router.push(.authScreen)
                        }
                    )
                }
            }
        }
        .padding(.bottom, 80)
        .onReceive(NotificationCenter.default.publisher(for: UserDefaults.didChangeNotification).receive(on: DispatchQueue.main)) { _ in
            name = ZelPreferences.username
        }
        .alert("Select Theme", isPresented: $showThemePicker) {
            ForEach(Theme.allCases, id: \.self) { theme in
                Button(
                    action: {
                        ZelPreferences.selectedTheme = theme
                        applyTheme(theme)
                    },
                    label: {
                        Text(
                            ZelPreferences.selectedTheme == theme ? "✓ \(theme.rawValue)" : theme.rawValue
                        )
                    }
                )
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Choose your preferred theme")
        }
        .alert("Log Out", isPresented: $showLogout) {
            Button {
                ZelPreferences.clearAll()
                DispatchQueue.main.async {
                    dismiss()
                }
            } label: {
                Text("Logout")
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Log out of Zellfarms")
        }
        .alert("Delete Account", isPresented: $showDelete) {
            Button {
                Task {
                    await authRepo.initiateDelete()
                }
            } label: {
                Text("Delete")
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Delete your account\nThis action cannot be undone")
                .multilineTextAlignment(.center)
        }
        .onAppear {
            applyTheme(ZelPreferences.selectedTheme)
            authRepo.router = router
        }
    }
}
