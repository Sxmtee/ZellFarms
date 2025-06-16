//
//  HelpCenter.swift
//  ZellFarms
//
//  Created by mac on 12/06/2025.
//

import SwiftUI

struct HelpCenter: View {
    @State private var emailText = ""
    
    private func sendEmail() {
        let recipient = "customercare@zellfarms.com"
        let subject = "Customer Support Request"
        let encodedBody = emailText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let mailtoString = "mailto:\(recipient)?subject=\(subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&body=\(encodedBody)"
        
        if let mailtoURL = URL(string: mailtoString) {
            UIApplication.shared.open(mailtoURL)
        }
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading) {
                TextEditor(text: $emailText)
                    .frame(minHeight: 500)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
                
                CustomButton(
                    action: {
                        sendEmail()
                    },
                    width: .infinity,
                    text: "Send to Customer Care"
                )
            }
            .padding(15)
        }
        .navigationTitle("Customer care")
        .scrollBounceBehavior(.basedOnSize)
    }
}

#Preview {
    HelpCenter()
}
