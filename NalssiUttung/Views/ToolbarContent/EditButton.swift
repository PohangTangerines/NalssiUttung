//
//  EditButton.swift
//  NalssiUttung
//
//  Created by 금가경 on 11/2/24.
//

import SwiftUI

struct EditButton: View {
    @ObservedObject var toolbarViewModel = ToolbarViewModel()
    
    var body: some View {
        Button {
            withAnimation {
                toolbarViewModel.isEditMode.toggle()
                print(toolbarViewModel.isEditMode)
            }
        } label: {
            Text(toolbarViewModel.isEditMode ? "완료" : "편집")
                .font(.pretendardMedium(.callout))
                .foregroundColor(Color.darkChacoal)
                .frame(maxWidth: 40.responsibleWidth, maxHeight: 40.responsibleHeight, alignment: .trailing)
        }
    }
}

#Preview {
    EditButton()
}
