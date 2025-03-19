//
//  TabButton.swift
//  ZellFarms
//
//  Created by mac on 18/03/2025.
//


import SwiftUI

struct TabButton: View {
    var tab: Tab
    @Binding var currentTab: Tab
    
    var body: some View {
        Button {
            withAnimation {
                currentTab = tab
            }
        } label: {
            Image(systemName: tab.iconName)
                .resizable()
                .scaledToFit()
                .frame(width: 25, height: 25)
        }
        .foregroundColor(currentTab == tab ? .accent : .secondary)
        .frame(maxWidth: .infinity)
    }
}
