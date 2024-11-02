//
//  AddButton.swift
//  NalssiUttung
//
//  Created by 금가경 on 10/21/24.
//

import SwiftUI

struct AddButton: View {
    var action: () -> Void = {}
    var mode: WeatherDisplayMode
    @Binding var isModalPresented: Bool
    @Binding var isTextFieldActive: Bool
    
    var body: some View {
        switch mode {
        case .regular:
            NavigationLink(destination: LocationListView()) {
                Image(systemName: "plus")
                    .font(.pretendardSemibold(.body))
                    .foregroundColor(.black)
            }
        case .modal:
            Button {
                action()
                isModalPresented = false
                isTextFieldActive = false
            } label: {
                Text("추가")
                    .font(.pretendardSemibold(.body))
                    .foregroundColor(.black)
            }
        case .modalInList:
            Spacer()
        }
    }
}

#Preview {
    AddButton(mode: .modal, isModalPresented: .constant(true), isTextFieldActive: .constant(true))
}
