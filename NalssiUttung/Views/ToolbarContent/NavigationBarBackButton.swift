//
//  NavigationBarBackButton.swift
//  NalssiUttung
//
//  Created by 금가경 on 11/2/24.
//

import SwiftUI

struct NavigationBarBackButton: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "chevron.left")
                .font(.system(size: 18).weight(.medium))
                .foregroundStyle(Color.black)
                .frame(maxWidth: 40, maxHeight: 40, alignment: .leading)
        }
    }
}

#Preview {
    NavigationBarBackButton()
}
