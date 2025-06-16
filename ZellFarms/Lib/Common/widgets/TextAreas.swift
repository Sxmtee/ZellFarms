//
//  TextAreas.swift
//  ZellFarms
//
//  Created by mac on 23/05/2025.
//

import SwiftUI

struct TextAreas: View {
    @Binding var text: String
    @State private var isPasswordVisible = false
    let title: String
    let hintText: String
    var borderColor: Color = .accentColor
    let icon: String
    var isSecureField = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 3.0) {
            Text(title)
                .font(.system(size: 20, weight: .medium))
            
            HStack {
                // Prefix Icon
                Image(systemName: icon)
                    .foregroundColor(.accentColor)
                    .frame(width: 20, height: 20)
                    .padding(.leading, 15)
                
                // Text Input
                if isSecureField {
                    Group {
                        if isPasswordVisible {
                            TextField(hintText, text: $text)
                        } else {
                            SecureField(hintText, text: $text)
                        }
                    }
                    .textFieldStyle(.plain)
                    
                    // Password Toggle Button
                    Button(action: {
                        isPasswordVisible.toggle()
                    }) {
                        Image(systemName: isPasswordVisible ? "eye.fill" : "eye.slash.fill")
                            .foregroundColor(.accentColor)
                            .frame(width: 20, height: 20)
                    }
                    .padding(.trailing, 15)
                } else {
                    TextField(hintText, text: $text)
                        .textFieldStyle(.plain)
                }
            }
            .padding(.vertical, 15)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .strokeBorder(borderColor, lineWidth: 1)
            )
        }
    }
}
