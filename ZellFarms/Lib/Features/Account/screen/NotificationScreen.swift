//
//  NotificationScreen.swift
//  ZellFarms
//
//  Created by mac on 26/05/2025.
//

import SwiftUI

struct NotificationScreen: View {
    var body: some View {
        VStack {
            Image(systemName: "bell.badge")
                .font(.title)
                .padding(.bottom, 5)
            Text("You haven't gotten any notifications yet!")
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.bottom, 5)
            Text("We'll alert you when something cool happens")
                .font(.title3)
                .multilineTextAlignment(.center)
                .padding(.bottom, 5)
        }
        .navigationTitle("Notifications")
        .padding(15)
    }
}
