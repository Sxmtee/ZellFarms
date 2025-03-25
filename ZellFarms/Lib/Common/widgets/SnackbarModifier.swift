//
//  SnackbarModifier.swift
//  ZellFarms
//
//  Created by mac on 19/03/2025.
//


import SwiftUI

struct SnackbarModifier: ViewModifier {
    @Binding var isShowing: Bool
    let message: String
    let isSuccess: Bool
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            if isShowing {
                VStack {
                    HStack(spacing: 12) {
                        Image(systemName: isSuccess ? "checkmark.circle.fill" : "exclamationmark.circle.fill")
                            .foregroundColor(.white)
                        
                        Text(message)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.leading)
                            .font(.system(size: 14, weight: .medium))
                        
                        Spacer()
                        
                        Button {
                            withAnimation {
                                isShowing = false
                            }
                        } label: {
                            Image(systemName: "xmark")
                                .foregroundColor(.white)
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(isSuccess ? Color.green.opacity(0.9) : Color.red.opacity(0.9))
                    )
                    .padding(.horizontal)
                    .padding(.top, 20) // Adjusted padding for top placement
                    
                    Spacer() // Pushes the snackbar to the top
                }
                .transition(.move(edge: .top).combined(with: .opacity))
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
                        withAnimation {
                            isShowing = false
                        }
                    }
                }
            }
        }
    }
}

extension View {
    func snackbar(isShowing: Binding<Bool>, message: String, isSuccess: Bool = false) -> some View {
        modifier(SnackbarModifier(isShowing: isShowing, message: message, isSuccess: isSuccess))
    }
}
