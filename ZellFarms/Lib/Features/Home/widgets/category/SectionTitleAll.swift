//
//  SectionTitleAll.swift
//  ZellFarms
//
//  Created by mac on 10/04/2025.
//

import SwiftUI

struct SectionTitleAll: View {
    var title: String
    var titleAll: String
    var onTap: (()->())?
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 24, weight: .semibold))
                .foregroundStyle(Color.primary)
            
            Spacer()
            
            Text(titleAll)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(Color.accentColor)
                .onTapGesture {
                    onTap?()
                }
        }
        .frame(height: 20)
    }
}
