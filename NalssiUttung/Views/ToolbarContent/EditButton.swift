//
//  EditButton.swift
//  NalssiUttung
//
//  Created by 금가경 on 11/2/24.
//

import SwiftUI

// TODO: - 검색 활성화 되었을 시 편집 버튼 뜨지 않도록 변경
struct EditButton: View {
    @ObservedObject var toolbarViewModel = ToolbarViewModel()
    
    var body: some View {
        Button {
            withAnimation {
                toolbarViewModel.isEditMode.toggle()
            }
        } label: {
            Text(toolbarViewModel.isEditMode ? "완료" : "편집")
                .font(.pretendardMedium(.callout))
                .foregroundStyle(Color.black)
                .frame(maxWidth: 40.responsibleWidth, maxHeight: 40.responsibleHeight, alignment: .trailing)
        }
    }
}

#Preview {
    EditButton()
}
