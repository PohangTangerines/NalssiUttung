//
//  NavigationBarBackButton.swift
//  NalssiUttung
//
//  Created by 금가경 on 11/2/24.
//

import SwiftUI

struct NavigationBarBackButton: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var toolbarViewModel: ToolbarViewModel

    var body: some View {
        Button {
            dismiss()
            toolbarViewModel.isEditMode = false
        } label: {
            Image(systemName: "chevron.left")
                .font(.system(size: 18).weight(.medium))
                .foregroundStyle(Color.black)
        }
    }
}

#Preview {
    NavigationBarBackButton()
}
