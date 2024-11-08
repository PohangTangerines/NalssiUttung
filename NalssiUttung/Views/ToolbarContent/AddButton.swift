//
//  AddButton.swift
//  NalssiUttung
//
//  Created by 금가경 on 10/21/24.
//

import SwiftUI

struct AddButton: View {
    @EnvironmentObject var toolbarViewModel: ToolbarViewModel
    @Environment(\.dismiss) var dismiss

    var action: () -> Void = {}
    var mode: WeatherDisplayMode

    var body: some View {
        switch mode {
        case .regular:
            NavigationLink(destination: WeatherByLocationView()) {
                Image(systemName: "plus")
                    .font(.pretendardSemibold(.body))
                    .foregroundStyle(.black)
            }
        case .modal:
            Button {
                action()
                dismiss()
                toolbarViewModel.isTextFieldActive = false
            } label: {
                Text("추가")
                    .font(.pretendardSemibold(.body))
                    .foregroundStyle(.black)
            }
        case .modalInList:
            Spacer()
        }
    }
}

#Preview {
    AddButton(mode: .modal)
}
