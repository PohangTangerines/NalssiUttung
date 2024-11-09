//
//  EditButton.swift
//  NalssiUttung
//
//  Created by 금가경 on 11/2/24.
//

import SwiftUI

struct EditButton: View {
    @EnvironmentObject var toolbarViewModel: ToolbarViewModel
    
    // TODO: - 완료버튼 안누르면 수정 반영 안되도록 하기
    var body: some View {
        if !toolbarViewModel.isTextFieldActive {
            Button {
                withAnimation {
                    toolbarViewModel.isEditMode.toggle()
                }
            } label: {
                Text(toolbarViewModel.isEditMode ? "완료" : "편집")
                    .font(.pretendardMedium(.callout))
                    .foregroundStyle(Color.black)
            }
        }
    }
}

#Preview {
    EditButton()
}
