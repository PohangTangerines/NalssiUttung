//
//  ScrolledMainViewTextDivider.swift
//  NalssiUttung
//
//  Created by 금가경 on 11/8/24.
//

import SwiftUI

struct TextDivider: View {
    let text: String
    
    var body: some View {
        HStack(spacing: 0) {
            Rectangle()
                .background(Color.black)
                .cornerRadius(10)
                .frame(minWidth: 95.25, maxHeight: 2)
            Text(text)
                .font(.IMHyemin(.footnote))
                .padding(.horizontal, 12)
            Rectangle()
                .background(Color.black)
                .cornerRadius(10)
                .frame(minWidth: 95.25, maxHeight: 2)
        }
    }
}
