//
//  ListTile.swift
//  ZellFarms
//
//  Created by mac on 16/05/2025.
//

import SwiftUI

struct ListTile: View {
    let leadingIcon: String
    let title: String
    let trailingIcon: String?
    let textColor: Color
    let action: () -> Void
    
    init(
        leadingIcon: String,
        title: String,
        trailingIcon: String?,
        textColor: Color = .primary,
        action: @escaping () -> Void
    ) {
        self.leadingIcon = leadingIcon
        self.title = title
        self.trailingIcon = trailingIcon
        self.textColor = textColor
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: leadingIcon)
                    .font(.system(size: 24))
                    .foregroundColor(textColor)
                    .frame(width: 30, alignment: .leading)
                
                Text(title)
                    .font(.system(size: 17, weight: .regular))
                    .foregroundColor(textColor)
                
                Spacer()
                
                if let trailingIcon = trailingIcon {
                    Image(systemName: trailingIcon)
                        .font(.system(size: 16))
                        .foregroundColor(.secondary)
                }
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
        }
        .buttonStyle(.plain)
        .contentShape(Rectangle())
    }
}

#Preview {
    ListTile(
        leadingIcon: "person",
        title: "My Profile",
        trailingIcon: "chevron.right",
        action: {

        }
    )
}
