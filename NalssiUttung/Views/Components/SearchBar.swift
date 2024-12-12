//
//  SerchBar.swift
//  NalssiUttung
//
//  Created by 금가경 on 11/2/24.
//

import SwiftUI

struct SearchBar: View {
    @ObservedObject var toolbarViewModel: ToolbarViewModel
    @FocusState var isFocused: Bool
    
    // TODO: - 키보드 등장할 때마다 오류 발생. FocusState 자체의 문제로 추정
    var body: some View {
        HStack {
            HStack(spacing: 5.responsibleWidth) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(Color.black)
                
                TextField("title",
                          text: $toolbarViewModel.searchText,
                          prompt:
                            withAnimation {
                    toolbarViewModel.isEditMode ? Text("편집 모드 해제 후 검색이 가능합니다.") : Text("지역 검색하기")
                    
                }
                    .foregroundStyle(Color.black)
                )
                .font(.pretendardMedium(.callout))
                .contentShape(RoundedRectangle(cornerRadius: 10))
                .focused($isFocused)
                .onTapGesture {
                    withAnimation {
                        isFocused = true
                    }
                }
                .disabled(toolbarViewModel.isEditMode)
            }
            .padding(.horizontal, 6.responsibleWidth)
            .padding(.vertical, 28.responsibleHeight)
            .frame(maxHeight: 45.responsibleHeight, alignment: .leading)
            .overlay(RoundedRectangle(cornerRadius: 10)
                .stroke(Color.black, lineWidth: 2))
            
            if isFocused {
                Button {
                    isFocused = false
                } label: {
                    Text("취소")
                        .font(.pretendardSemibold(.callout))
                        .foregroundStyle(Color.black)
                        .frame(maxWidth: 40.responsibleWidth, maxHeight: 40.responsibleHeight, alignment: .trailing)
                }
            }
        }
        .onChange(of: isFocused) { _, newValue in
            withAnimation {
                toolbarViewModel.isTextFieldActive = newValue
                toolbarViewModel.searchText = ""
            }
        }
    }
}

#Preview {
    SearchBar(toolbarViewModel: ToolbarViewModel())
}
