//
//  SerchBar.swift
//  NalssiUttung
//
//  Created by 금가경 on 11/2/24.
//

import SwiftUI

// TODO: - Combine 활용해서 입력 받기
// TODO: - FocusState 되면 EmptyView 띄우기
struct SearchBar: View {
    @ObservedObject var toolbarViewModel: ToolbarViewModel
    
    var body: some View {
        HStack {
            HStack(spacing: 5.responsibleWidth) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(Color.black)
                
                TextField("title", text: $toolbarViewModel.searchText, prompt: Text("지역 검색하기")
                    .foregroundStyle(Color.black))
                .font(.pretendardMedium(.callout))
                .contentShape(RoundedRectangle(cornerRadius: 10))
                .onTapGesture {
                    withAnimation {
                        toolbarViewModel.isTextFieldActive = true
                    }
                }
            }
            .padding(.horizontal, 6.responsibleWidth)
            .padding(.vertical, 28.responsibleHeight)
            .frame(maxHeight: 45.responsibleHeight, alignment: .leading)
            .overlay(RoundedRectangle(cornerRadius: 10)
                .stroke(Color.black, lineWidth: 2))
            
            if toolbarViewModel.isTextFieldActive {
                Button {
                    toolbarViewModel.isTextFieldActive = false
                    toolbarViewModel.searchText = ""
                } label: {
                    Text("취소")
                        .font(.pretendardSemibold(.callout))
                        .foregroundStyle(Color.black)
                        .frame(maxWidth: 40.responsibleWidth, maxHeight: 40.responsibleHeight, alignment: .trailing)
                }
            }
        }
    }
}

#Preview {
    SearchBar(toolbarViewModel: ToolbarViewModel())
}
