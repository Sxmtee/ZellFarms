//
//  ZellFarmsApp.swift
//  ZellFarms
//
//  Created by mac on 17/03/2025.
//

import SwiftUI

@main
struct ZellFarmsApp: App {
    @State private var router = Router()
    
    var body: some Scene {
        WindowGroup {
            ZellFarmsAppRoot()
                .environment(router)
        }
    }
}
