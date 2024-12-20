//
//  AddButton.swift
//  NalssiUttung
//
//  Created by 금가경 on 10/21/24.
//

import SwiftUI

struct AddButton: View {
    // TODO: - 왜 dismiss와 isModalPresented가 둘다?
    @EnvironmentObject var toolbarViewModel: ToolbarViewModel
    @Environment(\.dismiss) var dismiss
    private let coreDataStack = CoreDataStack.shared
    
    var locationInfo: LocationInfo?
    var mode: WeatherDisplayMode

    var body: some View {
        switch mode {
        case .regular:
            NavigationLink(destination: LocalizedWeatherView()) {
                Image(systemName: "plus")
                    .font(.pretendardSemibold(.body))
                    .foregroundStyle(.black)
            }
        case .modal:
            Button {
                coreDataStack.save(locationInfo: locationInfo)
                dismiss()
                toolbarViewModel.isTextFieldActive = false
                toolbarViewModel.isModalPresented = false
                dismissKeyboard()
            } label: {
                Text("추가")
                    .font(.pretendardSemibold(.body))
                    .foregroundStyle(.black)
            }
        case .modalInList:
            Spacer()
        }
    }
    
    private func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    AddButton(mode: .modal)
}
