//
//  ZelPreferences.swift
//  ZellFarms
//
//  Created by mac on 19/04/2025.
//

import Foundation

@propertyWrapper
struct UserDefault<T> {
    let key: String
    let defaultValue: T
    
    init(_ key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    var wrappedValue: T {
        get {
            UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}

class ZelPreferences {
    @UserDefault("username", defaultValue: "")
    static var username: String
    
    @UserDefault("email", defaultValue: "")
    static var email: String
    
    @UserDefault("accessToken", defaultValue: "")
    static var accessToken: String
    
    @UserDefault("selectedTheme", defaultValue: Theme.system.rawValue)
    private static var selectedThemeRaw: String
    
    // Public getter/setter for Theme enum
    static var selectedTheme: Theme {
        get {
            Theme(rawValue: selectedThemeRaw) ?? .system
        }
        set {
            selectedThemeRaw = newValue.rawValue
        }
    }
    
    static func clearAll() {
        DispatchQueue.main.async {
            let domain = Bundle.main.bundleIdentifier!
            UserDefaults.standard.removePersistentDomain(forName: domain)
            username = ""
            email = ""
            accessToken = ""
            selectedTheme = .system
        }
    }
}
