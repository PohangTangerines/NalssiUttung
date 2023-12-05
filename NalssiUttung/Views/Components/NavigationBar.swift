//
//  LocationListView.swift
//  NalssiUttung
//
//  Created by CHANG JIN LEE on 2023/09/11.

import SwiftUI

struct NavigationBar: View {
    @Binding var searchText: String
    @Binding var isEditMode: Bool
    @Binding var isTextFieldActive: Bool
    @FocusState var isFocused: Bool
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            HStack {
                Button {
                    isTextFieldActive = false
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18).weight(.medium))
                        .foregroundColor(Color.basalt)
                        .frame(maxWidth: 40, maxHeight: 40, alignment: .leading)
                }

                Text("지역 추가하기")
                    .font(.pretendardSemibold(.callout))
                    .foregroundColor(Color.darkChacoal)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                
                Button {
                    withAnimation {
                        if !isTextFieldActive {
                            self.isEditMode.toggle() // 편집 모드를 토글합니다.
                        }
                    }
                } label: {
                    Text(isEditMode ? "완료" : "편집")
                        .font(.pretendardMedium(.callout))
                        .foregroundColor(Color.darkChacoal)
                        .frame(maxWidth: 40.responsibleWidth, maxHeight: 40.responsibleHeight, alignment: .trailing)
                }
            }
            searchBar
        }
        .frame(height: 106.responsibleHeight, alignment: .top)
        .padding(.horizontal, 20.responsibleWidth)
        .padding(.top, 64.responsibleHeight)
        .background(Color.seaSky)
        .frame(maxHeight: .infinity, alignment: .top)
        .ignoresSafeArea()
        .navigationBarHidden(true)
    }

    private var searchBar: some View {
        HStack {
            HStack(spacing: 2.responsibleWidth) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(Color.darkChacoal)

                TextField("title", text: $searchText, prompt: Text("지역 검색하기").foregroundColor(Color.darkChacoal))
                    .font(.pretendardMedium(.callout))
                    .focused($isFocused)
                    .contentShape(RoundedRectangle(cornerRadius: 10))
                    .onTapGesture {
                        withAnimation {
                            isTextFieldActive = true
                            UIApplication.shared.sendAction(#selector(UIResponder.becomeFirstResponder), to: nil, from: nil, for: nil)
                        }
                    }
                    .onChange(of: isTextFieldActive) { focused in
                        if !focused {
                            searchText = "" // $searchText가 ""이 됨
                        }
                    }

            }
            .foregroundColor(.secondary)
            .padding(.horizontal, 6.responsibleWidth)
            .padding(.vertical, 28.responsibleHeight)
            .frame(maxHeight: 45.responsibleHeight, alignment: .leading)
            .background(Color.seaSky, in: RoundedRectangle(cornerRadius: 10))
            .overlay(RoundedRectangle(cornerRadius: 10)
                .stroke(Color.darkChacoal, lineWidth: 2))

            if isTextFieldActive {
                Button(action: {
                    isFocused = false
                    isTextFieldActive = false
                    searchText = ""
                }, label: {
                    Text("취소")
                        .font(.pretendardSemibold(.callout))
                        .foregroundColor(Color.darkChacoal)
                        .frame(maxWidth: 40.responsibleWidth, maxHeight: 40.responsibleHeight, alignment: .trailing)
                })

            }
        }
    }
}
